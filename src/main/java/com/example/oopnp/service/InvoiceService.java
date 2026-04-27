package com.example.oopnp.service;

import com.example.oopnp.entity.*;
import com.example.oopnp.repository.DeveloperRepository;
import com.example.oopnp.repository.InvoiceRepository;
import com.example.oopnp.repository.ProjectAssignmentRepository;
import com.example.oopnp.repository.ProjectRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.cache.annotation.CacheEvict;
import org.springframework.cache.annotation.Cacheable;
import org.springframework.cache.annotation.Caching;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.List;

@Service
@RequiredArgsConstructor
public class InvoiceService {

    private final InvoiceRepository invoiceRepository;
    private final ProjectRepository projectRepository;
    private final DeveloperRepository developerRepository;
    private final ProjectAssignmentRepository projectAssignmentRepository;


    // метод для розрахунку собівартості
    public Double calculateDevCosts(Long projectId) {

        List<ProjectAssignment> assignments = projectAssignmentRepository.findByProjectId(projectId);
        return assignments.stream()
                .filter(a -> !a.isActive())
                .mapToDouble(a -> {
                    double hours = a.getSpentHours() + (a.getSpentMinutes() / 60.0);
                    double rate = a.getDeveloper().getHourlyRate() != null ? a.getDeveloper().getHourlyRate() : 0.0;
                    return hours * rate;
                }).sum();

    }

    // save
    @Transactional
    @Caching(evict = {
            @CacheEvict(value = "invoices", allEntries = true),
            @CacheEvict(value = "projects", allEntries = true),
            @CacheEvict(value = "developers", allEntries = true)
    })
    public Invoice saveNewInvoice(Long projectId, Double finalPrice) {

        Double devCosts = calculateDevCosts(projectId);

        // перевірка мінімальної ціни
        if (finalPrice < devCosts) {
            throw new IllegalArgumentException("Ціна не може бути меншою за собівартість виплат розробникам (" + devCosts + "$)");
        }

        Project project = projectRepository.findById(projectId)
                .orElseThrow(() -> new IllegalArgumentException("Проєкт не знайдено"));

        project.setStatus(ProjectStatus.INVOICED);


        // чи всі таски завершені
        boolean hasActiveTasks = projectAssignmentRepository.existsByProjectIdAndIsActiveTrue(projectId);
        if (hasActiveTasks) {
            throw new IllegalStateException("Неможливо створити рахунок: на проєкті ще є активні завдання.");
        }

        // створення інвойсу
        Invoice invoice = new Invoice();
        invoice.setProject(project);
        invoice.setStatus(InvoiceStatus.PENDING);
        invoice.setDevCosts(devCosts);
        invoice.setFinalPrice(finalPrice);

        // проект з інвойсом знімаємо з поточного у девів
        List<Developer> developers = developerRepository.findByCurrentProjectId(projectId);
        for (Developer developer : developers) {
           developer.setCurrentProject(null);
        }

        return invoiceRepository.save(invoice);
    }

    // update
    @Transactional
    @Caching(evict = {
            @CacheEvict(value = "invoices", allEntries = true),
            @CacheEvict(value = "projects", allEntries = true)
    })
    public Invoice updateInvoice(Long invoiceId, Double newFinalPrice, String newStatus) {
        Invoice invoice = findById(invoiceId);

        // не можна редагувати оплачені чи відхилені рахунки
        if (invoice.getStatus() == InvoiceStatus.PAID || invoice.getStatus() == InvoiceStatus.CANCELLED) {
            throw new IllegalStateException("Неможливо змінити рахунок, який вже оплачено чи відхилено!");
        }

        if (newStatus.equals("PAID")) {
            throw new IllegalArgumentException("Статус 'ОПЛАЧЕНО' встановлюється автоматично системою.");
        }

        InvoiceStatus parsedNewStatus = InvoiceStatus.valueOf(newStatus);

        // зміна СТАТУСУ чи зміна ЦІНИ?
        if (invoice.getStatus() != parsedNewStatus) {

            // змінюється статус
            // ігноруємо нову ціну, оновлюємо тільки статус
            invoice.setStatus(parsedNewStatus);

            // якщо рахунок анульовано, звільняємо проєкт для нового рахунку
            if (parsedNewStatus == InvoiceStatus.CANCELLED && invoice.getProject() != null) {
                invoice.getProject().setStatus(ProjectStatus.COMPLETED);
            }

        } else {

            // статус не змінився, змінюєм ЦІНУ
            if (newFinalPrice < invoice.getDevCosts()) {
                throw new IllegalArgumentException("Нова ціна не може бути меншою за собівартість ($" + invoice.getDevCosts() + ")");
            }
            invoice.setFinalPrice(newFinalPrice);
        }

        return invoiceRepository.save(invoice);
    }

    // pay
    @Transactional
    @Caching(evict = {
            @CacheEvict(value = "invoices", allEntries = true),
            @CacheEvict(value = "projects", allEntries = true),
            @CacheEvict(value = "developers", allEntries = true)
    })
    public void payInvoice(Long invoiceId) {
        Invoice invoice = invoiceRepository.findById(invoiceId)
                .orElseThrow(() -> new IllegalArgumentException("Рахунок не знайдено"));

        if (invoice.getStatus() == InvoiceStatus.PAID || invoice.getStatus() == InvoiceStatus.CANCELLED) {
            throw new IllegalStateException("Цей рахунок неможливо оплатити.");
        }

        invoice.setStatus(InvoiceStatus.PAID);
        invoice.setCompletedAt(LocalDateTime.now());

        Project project = invoice.getProject();
        if(project != null) {
            project.setStatus(ProjectStatus.CLOSED);
            project.setCompletedAt(LocalDateTime.now());

            List<Developer> assignedDevelopers = developerRepository.findByCurrentProjectId(project.getId());
            for (Developer developer : assignedDevelopers) {
                developer.setCurrentProject(null);
            }
        }

    }


    // find
    @Cacheable(value = "invoices", key = "'all'")
    public List<Invoice> findAllInvoices() { return invoiceRepository.findAll(); }

    @Cacheable(value = "invoices", key = "'inv_' + #invoiceId")
    public Invoice findById(Long invoiceId) { return invoiceRepository.findById(invoiceId)
            .orElseThrow(() -> new IllegalArgumentException("Рахунок не знайдено"));}

}

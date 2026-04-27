package com.example.oopnp.service;

import com.example.oopnp.entity.*;
import com.example.oopnp.repository.*;
import lombok.RequiredArgsConstructor;
import org.springframework.cache.annotation.CacheEvict;
import org.springframework.cache.annotation.Cacheable;
import org.springframework.cache.annotation.Caching;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
@RequiredArgsConstructor
public class ProjectService {

    private final ProjectRepository projectRepository;
    private final ProjectAssignmentRepository projectAssignmentRepository;
    private final CustomerRepository customerRepository;
    private final ManagerRepository managerRepository;
    private final DeveloperRepository developerRepository;

    private static final String PROJECT_NOT_FOUND_MASSAGE = "Проєкт не знайдено";



    // save
    // замовник створює проєкт (замовлення) з назвою та описом
    @Transactional
    @Caching(evict = {
            @CacheEvict(value = "projects", allEntries = true),
            @CacheEvict(value = "customers", allEntries = true)
    })
    public Project saveNewProjectAsCustomer(Project project, Long userId) {

        Customer customer = customerRepository.findByUserId(userId)
                .orElseThrow(() -> new IllegalArgumentException("Замовника з id: " + userId + " не знайдено"));

        project.setCustomer(customer);
        project.setStatus(ProjectStatus.PROPOSAL);

        // інші поля будуть заповнюватись по мірі виконання проєкту

        return projectRepository.save(project);
    }


    // update
    @Transactional
    @Caching(evict = {
            @CacheEvict(value = "projects", allEntries = true),
            @CacheEvict(value = "managers", allEntries = true),
            @CacheEvict(value = "developers", allEntries = true),
            @CacheEvict(value = "customers", allEntries = true),
            @CacheEvict(value = "assignments", allEntries = true)
    })
    public Project updateProjectByAdmin(Long projectId, Project updatedProject, Long managerId) {
        Project existingProject = projectRepository.findById(projectId)
                .orElseThrow(() -> new IllegalArgumentException(PROJECT_NOT_FOUND_MASSAGE));

        existingProject.setTitle(updatedProject.getTitle());
        existingProject.setDescription(updatedProject.getDescription());
        existingProject.setStatus(updatedProject.getStatus());

        if (managerId != null) {
            Manager manager = managerRepository.findById(managerId)
                    .orElseThrow(() -> new IllegalArgumentException("Менеджера не знайдено"));
            existingProject.setManager(manager);


            if (!manager.getAllProjects().contains(existingProject)) {
                manager.getAllProjects().add(existingProject);
            }
        } else {
            existingProject.setManager(null);
        }

        return projectRepository.save(existingProject);
    }


    @Transactional
    @Caching(evict = {
            @CacheEvict(value = "projects", allEntries = true),
            @CacheEvict(value = "developers", allEntries = true),
            @CacheEvict(value = "assignments", allEntries = true)
    })
    public Project updateProjectByManager(Long projectId, Project updatedProject, List<Long> developerIds) {
        Project existingProject = projectRepository.findById(projectId)
                .orElseThrow(() -> new IllegalArgumentException(PROJECT_NOT_FOUND_MASSAGE));

        existingProject.setTitle(updatedProject.getTitle());
        existingProject.setDescription(updatedProject.getDescription());
        existingProject.setStatus(updatedProject.getStatus());

        if (developerIds != null && !developerIds.isEmpty()) {
            for (Long devId : developerIds) {
                Developer dev = developerRepository.findById(devId)
                        .orElseThrow(() -> new IllegalArgumentException("Розробника не знайдено"));

                dev.setCurrentProject(existingProject);

                if (!dev.getAllProjects().contains(existingProject)) {
                    dev.getAllProjects().add(existingProject);
                }
                developerRepository.save(dev);
            }
        }

        return projectRepository.save(existingProject);
    }

    //delete
    @Transactional
    @Caching(evict = {
            @CacheEvict(value = "projects", allEntries = true),
            @CacheEvict(value = "managers", allEntries = true),
            @CacheEvict(value = "developers", allEntries = true),
            @CacheEvict(value = "customers", allEntries = true)
    })
    public void deleteProject(Long projectId) {

        Project project = projectRepository.findById(projectId)
                .orElseThrow(() -> new IllegalArgumentException(PROJECT_NOT_FOUND_MASSAGE));

        // чи є пов'язані завдання
        if (projectAssignmentRepository.existsByProjectId(projectId)) {
            throw new IllegalStateException("Неможливо видалити проєкт, бо по ньому вже є звіти про виконану роботу. Спершу видаліть завдання.");
        }

        // прибираємо цей проєкт у девів і менеджерів
        List<Developer> assignedDevelopers = developerRepository.findByCurrentProjectId(projectId);
        for (Developer dev : assignedDevelopers) {
            dev.setCurrentProject(null);
            dev.getAllProjects().remove(project);
        }
        developerRepository.saveAll(assignedDevelopers);

        Manager assignedManager = managerRepository.findByAllProjects_Id(projectId);
        if (assignedManager != null && assignedManager.getAllProjects().contains(project)) {
            assignedManager.getAllProjects().remove(project);
            managerRepository.save(assignedManager);
        }

        projectRepository.delete(project);
    }


    // find
    @Cacheable(value = "projects", key = "'all'")
    public List<Project> findAllProjects() {
        return projectRepository.findAll();
    }

    @Cacheable(value = "projects", key = "'proj_' + #projectId")
    public Project findProjectById(Long projectId) {
        return  projectRepository.findById(projectId)
            .orElseThrow(() -> new IllegalArgumentException("Проєкт з ID " + projectId + " не знайдено")); }

    @Cacheable(value = "projects", key = "'all_sorted_admin'")
    public List<Project> findProjectsSortedForAdmin() {
        return projectRepository.findAllProjectsSortedByStatus();
    }

    @Cacheable(value = "projects", key = "'customer_' + #userId")
    public List<Project> findProjectsForCustomer(Long userId) {
        return projectRepository.findProjectsForCustomerSortedByStatus(userId);
    }

    @Cacheable(value = "projects", key = "'manager_' + #userId")
    public List<Project> findProjectsForManager(Long userId) {
        return projectRepository.findProjectsForManagerSortedByStatus(userId);
    }

    @Cacheable(value = "projects", key = "'dev_' + #userId")
    public List<Project> findProjectsForDeveloper(Long userId) {
        return projectRepository.findProjectsForDeveloperSortedByStatus(userId);
    }

    @Cacheable(value = "projects", key = "'all_with_invoices'")
    public List<Project> findProjectsWithInvoices() { return projectRepository.findProjectsWithInvoices(); }

    @Cacheable(value = "projects", key = "'manager_invoices_' + #userId")
    public List<Project> findProjectsWithInvoicesByManager(Long userId) { return projectRepository.findProjectsWithInvoicesByManager(userId); }

    @Cacheable(value = "projects", key = "'customer_invoices_' + #userId")
    public List<Project> findProjectsWithInvoicesByCustomer(Long userId) { return projectRepository.findProjectsWithInvoicesByCustomer(userId); }

}

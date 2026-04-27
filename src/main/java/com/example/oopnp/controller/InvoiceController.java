package com.example.oopnp.controller;

import com.example.oopnp.entity.*;
import com.example.oopnp.service.InvoiceService;
import com.example.oopnp.service.ProjectAssignmentService;
import com.example.oopnp.service.ProjectService;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.Authentication;
import org.springframework.ui.Model;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.util.List;

@Controller
@RequiredArgsConstructor
@RequestMapping("/invoices")
public class InvoiceController {
    private final InvoiceService invoiceService;
    private final ProjectService projectService;
    private  final ProjectAssignmentService projectAssignmentService;

    private static final String ADMIN_PATH = "admin";
    private static final String MANAGER_PATH = "manager";
    private static final String ERROR_MASSAGE = "errorMessage";
    private static final String ROLE_ADMIN = "ROLE_admin";


    @GetMapping("/{id}")
    @PreAuthorize("hasAnyRole('admin', 'manager', 'customer')")
    public String viewInvoiceDetails(@PathVariable("id") Long id, Model model) {
        Invoice invoice = invoiceService.findById(id);

        // дістаємо всі завершені таски по цьому проєкту
        List<ProjectAssignment> completedTasks = projectAssignmentService.findAllProjectAssignmentsByProjectId(invoice.getProject().getId());

        model.addAttribute("invoice", invoice);
        model.addAttribute("tasks", completedTasks);

        return "invoice-details";
    }


    // create
    @GetMapping("/create/{projectId}")
    @PreAuthorize("hasAnyRole('admin', 'manager')")
    public String getCreateInvoiceForm(@PathVariable("projectId") Long projectId, Model model) {
        Project project = projectService.findProjectById(projectId);

        // рахуємо собівартість
        Double devCosts = invoiceService.calculateDevCosts(projectId);

        model.addAttribute("project", project);
        model.addAttribute("devCosts", devCosts);

        return "invoice-create";
    }


    @PostMapping("/create/{projectId}")
    @PreAuthorize("hasAnyRole('admin', 'manager')")
    public String createInvoice(@PathVariable Long projectId,
                                @RequestParam("finalPrice") Double finalPrice,
                                Authentication auth,
                                RedirectAttributes redirectAttributes) {

        boolean isAdmin = auth.getAuthorities().stream()
                .anyMatch(a -> a.getAuthority().equals(ROLE_ADMIN));
        String baseRedirect = isAdmin ? "redirect:/admin/projects" : "redirect:/manager/projects";


        try {
            invoiceService.saveNewInvoice(projectId, finalPrice);
            redirectAttributes.addFlashAttribute("successMessage", "Рахунок успішно виставлено!");
            return baseRedirect;

        } catch (IllegalArgumentException e) {
            redirectAttributes.addFlashAttribute(ERROR_MASSAGE, e.getMessage());
            String rolePath = isAdmin ? ADMIN_PATH : MANAGER_PATH;
            return "redirect:/" + rolePath + "/projects/" + projectId;
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute(ERROR_MASSAGE, e.getMessage());
            return baseRedirect;
        }
    }


    // update
    @GetMapping("/edit/{id}")
    @PreAuthorize("hasAnyRole('admin', 'manager')")
    public String getEditInvoiceForm(@PathVariable("id") Long id, Model model, RedirectAttributes redirectAttributes, Authentication authentication) {
        boolean isAdmin = authentication.getAuthorities().stream()
                .anyMatch(a -> a.getAuthority().equals(ROLE_ADMIN));

        String rolePath = isAdmin ? ADMIN_PATH : MANAGER_PATH;

        try {
            Invoice invoice = invoiceService.findById(id);

            // не можна редагувати оплачені чи відхилені рахунки
            if (invoice.getStatus() == InvoiceStatus.PAID | invoice.getStatus() == InvoiceStatus.CANCELLED) {
                redirectAttributes.addFlashAttribute(ERROR_MASSAGE, "Неможливо змінити рахунок, який вже оплачено чи відхилено!");
                return "redirect:/" + rolePath + "/invoices";
            }


            model.addAttribute("invoice", invoice);
            return "invoice-edit";

        } catch (Exception e) {
            redirectAttributes.addFlashAttribute(ERROR_MASSAGE, e.getMessage());
            return "redirect:/" + rolePath + "/invoices";
        }
    }


    @PostMapping("/edit/{id}")
    @PreAuthorize("hasAnyRole('admin', 'manager')")
    public String updateInvoice(@PathVariable Long id,
                                @RequestParam("finalPrice") Double finalPrice,
                                @RequestParam("status") String status,
                                RedirectAttributes redirectAttributes, Authentication authentication) {

        boolean isAdmin = authentication.getAuthorities().stream()
                .anyMatch(a -> a.getAuthority().equals(ROLE_ADMIN));

        String rolePath = isAdmin ? ADMIN_PATH : MANAGER_PATH;

        try {
            invoiceService.updateInvoice(id, finalPrice, status);
            redirectAttributes.addFlashAttribute("successMessage", "Суму рахунку успішно оновлено!");
            return "redirect:/" + rolePath + "/invoices";

        } catch (IllegalStateException | IllegalArgumentException e) {
            redirectAttributes.addFlashAttribute(ERROR_MASSAGE, e.getMessage());
            return "redirect:/invoices/edit/" + id;
        }
    }


}

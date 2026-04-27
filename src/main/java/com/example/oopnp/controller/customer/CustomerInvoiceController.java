package com.example.oopnp.controller.customer;

import com.example.oopnp.entity.User;
import com.example.oopnp.service.InvoiceService;
import com.example.oopnp.service.ProjectService;
import com.example.oopnp.service.UserService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.security.Principal;

@Controller
@RequiredArgsConstructor
@RequestMapping("/customer/invoices")
public class CustomerInvoiceController {

    private final InvoiceService invoiceService;
    private final ProjectService projectService;
    private final UserService userService;

    @GetMapping
    public String getCustomerInvoices(Principal principal, Model model) {
        User currentUser = userService.findUserByEmail(principal.getName());
        model.addAttribute("projectsWithInvoices", projectService.findProjectsWithInvoicesByCustomer(currentUser.getId()));
        return "invoices";
    }

    @PostMapping("/{id}/pay")
    public String payInvoice (@PathVariable Long id, RedirectAttributes redirectAttributes) {
        try {
            invoiceService.payInvoice(id);
            redirectAttributes.addFlashAttribute("successMessage", "Рахунок успішно оплачено!");
            return "redirect:/customer/invoices";
        } catch (IllegalStateException | IllegalArgumentException e) {
            redirectAttributes.addFlashAttribute("errorMessage", e.getMessage());
            return "redirect:/customer/invoices";
        }
    }
}

package com.example.oopnp.controller.admin;

import com.example.oopnp.service.CustomerService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

@Controller
@RequiredArgsConstructor
@RequestMapping("/admin/customers")
public class AdminCustomerController {

    private final CustomerService customerService;

    @GetMapping
    public String getAdminCustomers(Model model) {
        model.addAttribute("customers", customerService.findAllCustomersWithSortedProjects());
        return "customers";
    }

    @PostMapping("/delete/{id}")
    public String deleteCustomer(@PathVariable Long id, RedirectAttributes redirectAttributes) {
        try {
            customerService.deleteCustomerById(id);
            redirectAttributes.addFlashAttribute("successMessage", "Клієнта успішно видалено");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("errorMessage", "Неможливо видалити клієнта: він прив'язаний до активних проєктів");
            return "redirect:/admin/customers";
        }
        return "redirect:/admin/customers";
    }
}

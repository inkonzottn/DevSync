package com.example.oopnp.controller.manager;

import com.example.oopnp.entity.*;
import com.example.oopnp.service.*;
import org.springframework.ui.Model;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

import java.security.Principal;


@Controller
@RequiredArgsConstructor
@RequestMapping("/manager")
public class MangerController {

    private final UserService userService;
    private final CustomerService customerService;
    private final DeveloperService developerService;
    private final InvoiceService invoiceService;
    private final ManagerService managerService;
    private final ProjectAssignmentService projectAssignmentService;
    private final ProjectService projectService;


    // CUSTOMERS
    @GetMapping("/customers")
    public String getManagerCustomers(Principal principal, Model model) {
        User currentUser = userService.findUserByEmail(principal.getName());
        model.addAttribute("customers", customerService.findCustomersForManager(currentUser.getId()));
        return "customers";
    }

    // DEVELOPERS
    @GetMapping("/developers")
    public String getManagerDevelopers(Model model) {
        model.addAttribute("developers", developerService.findAllDevelopers());
        return "developers";
    }

    // MANAGERS
    @GetMapping("/managers")
    public String getAllManagersDashboard(Model model) {
        model.addAttribute("managers", managerService.getAllManagersWithActiveProjects());
        return "managers";
    }

    // ASSIGNMENTS
    @GetMapping("/project-assignments")
    public String getManagerProjectAssignments(Principal principal, Model model) {
        User currentUser = userService.findUserByEmail(principal.getName());
        model.addAttribute("projectAssignments", projectAssignmentService.findProjectAssignmentsForManager(currentUser.getId()));
        return "project-assignments";
    }

    // INVOICES
    @GetMapping("/invoices")
    public String getManagerInvoices(Principal principal, Model model) {
        User currentUser = userService.findUserByEmail(principal.getName());
        model.addAttribute("projectsWithInvoices", projectService.findProjectsWithInvoicesByManager(currentUser.getId()));
        return "invoices";
    }

}

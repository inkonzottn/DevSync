package com.example.oopnp.controller.admin;

import com.example.oopnp.service.InvoiceService;
import com.example.oopnp.service.ProjectAssignmentService;
import com.example.oopnp.service.ProjectService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;


@Controller
@RequiredArgsConstructor
@RequestMapping("/admin")
public class AdminController {

    // TODO profile

    private final InvoiceService invoiceService;
    private final ProjectService projectService;
    private final ProjectAssignmentService projectAssignmentService;


    @GetMapping("/invoices")
    public String getAdminInvoices(Model model) {
        model.addAttribute("projectsWithInvoices", projectService.findProjectsWithInvoices());
        return "invoices";
    }


    @GetMapping("/project-assignments")
    public String getAdminProjectAssignments(Model model) {
        model.addAttribute("projectAssignments", projectAssignmentService.findAllProjectAssignments());
        return "project-assignments";
    }

}

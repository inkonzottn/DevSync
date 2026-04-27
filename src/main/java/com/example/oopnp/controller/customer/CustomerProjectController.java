package com.example.oopnp.controller.customer;

import com.example.oopnp.entity.Project;
import com.example.oopnp.entity.User;
import com.example.oopnp.service.ProjectService;
import com.example.oopnp.service.UserService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.validation.FieldError;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import java.security.Principal;
import java.util.Map;
import java.util.stream.Collectors;

@Controller
@RequiredArgsConstructor
@RequestMapping("/customer/projects")
public class CustomerProjectController {

    private final ProjectService projectService;
    private final UserService userService;


    @GetMapping
    public String getCustomerProjects(Principal principal, Model model) {
        User currentUser = userService.findUserByEmail(principal.getName());
        model.addAttribute("projects", projectService.findProjectsForCustomer(currentUser.getId()));
        return "projects";
    }

    // create
    @GetMapping("/create")
    public String getProjectCreateForm(Model model) {
        return "project-create";
    }

    @PostMapping("/create")
    public String createProject(@Valid @ModelAttribute("project") Project project,
                                BindingResult bindingResult,
                                Principal principal,
                                Model model) {

        if (bindingResult.hasErrors()) {
            Map<String, String> errorsMap = bindingResult.getFieldErrors().stream()
                    .collect(Collectors.toMap(
                            FieldError::getField,
                            FieldError::getDefaultMessage,
                            (existing, replacement) -> existing
                    ));

            model.addAttribute("errors", errorsMap);

            return "project-create";
        }

        try {
            User currentUser = userService.findUserByEmail(principal.getName());

            projectService.saveNewProjectAsCustomer(project, currentUser.getId());

            return "redirect:/customer/projects";
        } catch (Exception e) {
            model.addAttribute("message", e.getMessage());
            return "project-create";
        }
    }
}

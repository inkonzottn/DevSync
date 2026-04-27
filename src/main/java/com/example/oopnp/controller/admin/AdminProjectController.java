package com.example.oopnp.controller.admin;

import com.example.oopnp.entity.*;
import com.example.oopnp.service.ManagerService;
import com.example.oopnp.service.ProjectService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.validation.FieldError;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.security.Principal;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@Controller
@RequiredArgsConstructor
@RequestMapping("/admin/projects")
public class AdminProjectController {

    private final ProjectService projectService;
    private final ManagerService managerService;


    @GetMapping
    public String getAdminProjects(Model model) {
        model.addAttribute("projects", projectService.findProjectsSortedForAdmin());
        return "projects";
    }

    // update
    @GetMapping("/edit/{id}")
    public String getProjectEditForm(@PathVariable Long id, Principal principal, Authentication auth, Model model) {
        Project project = projectService.findProjectById(id);
        List<Manager> managers = managerService.findAllManagers();

        model.addAttribute("project", project);
        model.addAttribute("managers", managers);
        model.addAttribute("statuses", ProjectStatus.values());

        return "admin-project-edit";
    }

    @PostMapping("/edit/{id}")
    public String updateProject(@PathVariable Long id,
                                @Valid @ModelAttribute("project") Project project,
                                BindingResult bindingResult,
                                @RequestParam(value = "managerId", required = false) Long managerId,
                                Model model) {


        if (bindingResult.hasErrors()) {
            model.addAttribute("errors", extractValidationErrors(bindingResult));
            model.addAttribute("project", project);
            model.addAttribute("manager", managerService.findAllManagers());
            model.addAttribute("statuses", ProjectStatus.values());
            return "admin-project-edit";
        }


        try {
            projectService.updateProjectByAdmin(id, project, managerId);
            return "redirect:/admin/projects";
        } catch (IllegalArgumentException e) {
            model.addAttribute("message", e.getMessage());
            model.addAttribute("project", project);
            model.addAttribute("manager", managerService.findAllManagers());
            model.addAttribute("statuses", ProjectStatus.values());
            return "admin-project-edit";
        }
    }

    // delete
    @PostMapping("/delete/{id}")
    public String deleteProject(@PathVariable Long id, RedirectAttributes redirectAttributes) {
        try {
            projectService.deleteProject(id);
            redirectAttributes.addFlashAttribute("successMessage", "Проєкт успішно видалено.");
        } catch (IllegalStateException e) {
            redirectAttributes.addFlashAttribute("errorMessage", e.getMessage());
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("errorMessage", "Сталася помилка при видаленні проєкту.");
        }

        return "redirect:/admin/projects";
    }

    private Map<String, String> extractValidationErrors(BindingResult bindingResult) {
        return bindingResult.getFieldErrors().stream()
                .collect(Collectors.toMap(
                        FieldError::getField,
                        FieldError::getDefaultMessage,
                        (existing, replacement) -> existing
                ));
    }
}

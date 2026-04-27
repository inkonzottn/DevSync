package com.example.oopnp.controller.manager;

import com.example.oopnp.entity.Developer;
import com.example.oopnp.entity.Project;
import com.example.oopnp.entity.ProjectStatus;
import com.example.oopnp.entity.User;
import com.example.oopnp.service.DeveloperService;
import com.example.oopnp.service.ProjectService;
import com.example.oopnp.service.UserService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.validation.FieldError;
import org.springframework.web.bind.annotation.*;

import java.security.Principal;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@Controller
@RequiredArgsConstructor
@RequestMapping("/manager/projects")
public class ManagerProjectController {

    private final ProjectService projectService;
    private final DeveloperService developerService;
    private final UserService userService;

    @GetMapping
    public String getManagerProjects(Principal principal, Model model) {
        User currentUser = userService.findUserByEmail(principal.getName());
        model.addAttribute("projects", projectService.findProjectsForManager(currentUser.getId()));
        return "projects";
    }

    // update
    @GetMapping("/edit/{id}")
    public String getMangerEditForm(@PathVariable Long id, Model model) {
        Project project = projectService.findProjectById(id);

        List<Developer> freeDevelopers = developerService.findFreeDevelopers();

        model.addAttribute("project", project);
        model.addAttribute("freeDevelopers", freeDevelopers);
        model.addAttribute("statuses", ProjectStatus.values());

        return "manager-project-edit";
    }

    @PostMapping("/edit/{id}")
    public String updateProject(@PathVariable Long id,
                                @Valid @ModelAttribute("project") Project project,
                                BindingResult bindingResult,
                                @RequestParam(value = "developerIds", required = false) List<Long> developerIds,
                                Model model) {

        if (bindingResult.hasErrors()) {
            Map<String, String> errorsMap = bindingResult.getFieldErrors().stream()
                    .collect(Collectors.toMap(
                            FieldError::getField,
                            FieldError::getDefaultMessage,
                            (existing, replacement) -> existing
                    ));

            model.addAttribute("errors", errorsMap);
            model.addAttribute("project", project);
            model.addAttribute("freeDevelopers", developerService.findFreeDevelopers());
            model.addAttribute("statuses", ProjectStatus.values());

            return "manager-project-edit";
        }

        try {
            projectService.updateProjectByManager(id, project, developerIds);
            return "redirect:/manager/projects";
        } catch (Exception e) {
            model.addAttribute("message", e.getMessage());
            model.addAttribute("project", project);
            model.addAttribute("freeDevelopers", developerService.findFreeDevelopers());
            model.addAttribute("statuses", ProjectStatus.values());
            return "manager-project-edit";
        }
    }
}

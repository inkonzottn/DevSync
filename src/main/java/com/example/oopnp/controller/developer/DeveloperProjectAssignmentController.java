package com.example.oopnp.controller.developer;

import com.example.oopnp.entity.Developer;
import com.example.oopnp.entity.Project;
import com.example.oopnp.entity.ProjectAssignment;
import com.example.oopnp.entity.User;
import com.example.oopnp.service.DeveloperService;
import com.example.oopnp.service.ProjectAssignmentService;
import com.example.oopnp.service.UserService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.validation.FieldError;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.security.Principal;
import java.util.Map;
import java.util.stream.Collectors;

@Controller
@RequiredArgsConstructor
@RequestMapping("/developer/project-assignments")
public class DeveloperProjectAssignmentController {

    private final UserService userService;
    private final DeveloperService developerService;
    private final ProjectAssignmentService projectAssignmentService;


    // create (start)
    @GetMapping("/create")
    public String getCreateForm(Model model, Principal principal) {

        User currentUser = userService.findUserByEmail(principal.getName());
        Developer developer = developerService.findByUserId(currentUser.getId());
        Project currentProject = developer.getCurrentProject();

        if (currentProject == null) {
            model.addAttribute("message", "У вас зараз немає активного проєкту. Ви не можете створювати завдання.");
            return "redirect:/developer/project-assignments";
        }

        model.addAttribute("currentProject", currentProject);
        model.addAttribute("assignment", new ProjectAssignment());

        return "project-assignment-create";
    }

    @PostMapping("/create")
    public String createProjectAssignment(@Valid @ModelAttribute("assignment") ProjectAssignment projectAssignment,
                                          BindingResult bindingResult,
                                          Principal principal,
                                          Model model) {

        User currentUser = userService.findUserByEmail(principal.getName());
        Developer developer = developerService.findByUserId(currentUser.getId());
        Project currentProject = developer.getCurrentProject();

        if (bindingResult.hasErrors()) {
            model.addAttribute("errors", extractValidationErrors(bindingResult));
            model.addAttribute("currentProject", currentProject);

            return "project-assignment-create";
        }

        try {
            projectAssignmentService.startProjectAssignment(projectAssignment, currentUser.getId(), currentProject.getId());

            return "redirect:/developer/project-assignments";
        } catch (Exception e) {
            model.addAttribute("message", e.getMessage());
            model.addAttribute("currentProject", currentProject);
            return "project-assignment-create";
        }
    }


    // update
    @GetMapping("/edit/{id}")
    public String getEditForm (@PathVariable Long id, Model model, Principal principal) {

        User currentUser = userService.findUserByEmail(principal.getName());
        ProjectAssignment assignment = projectAssignmentService.findProjectAssignmentById(id);

        if (!assignment.getDeveloper().getUser().getId().equals(currentUser.getId())) {
            return "redirect:/developer/project-assignments";
        }

        if (!assignment.isActive()) {
            return "redirect:/developer/project-assignments";
        }

        model.addAttribute("assignment", assignment);
        return "project-assignment-edit";
    }

    @PostMapping("/edit/{id}")
    public String updateProjectAssignment( @PathVariable Long id,
                                           @Valid @ModelAttribute("assignment") ProjectAssignment projectAssignment,
                                           BindingResult bindingResult,
                                           Principal principal,
                                           Model model) {

        User currentUser = userService.findUserByEmail(principal.getName());

        if (bindingResult.hasErrors()) {
            model.addAttribute("errors", extractValidationErrors(bindingResult));
            ProjectAssignment originalAssignment = projectAssignmentService.findProjectAssignmentById(id);
            projectAssignment.setProject(originalAssignment.getProject());
            model.addAttribute("assignment", projectAssignment);

            return "project-assignment-edit";
        }

        try {
            projectAssignmentService.updateProjectAssignment(id, projectAssignment, currentUser.getId());
            return "redirect:/developer/project-assignments";
        } catch (Exception e) {
            model.addAttribute("message", e.getMessage());

            ProjectAssignment originalAssignment = projectAssignmentService.findProjectAssignmentById(id);
            projectAssignment.setProject(originalAssignment.getProject());
            model.addAttribute("assignment", projectAssignment);

            return "project-assignment-edit";
        }
    }


    // finish
    @PostMapping("/finish/{id}")
    public String finishAssignmentFromModal(@PathVariable("id") Long id,
                                            @RequestParam(defaultValue = "0") Integer spentHours,
                                            @RequestParam(defaultValue = "0") Integer spentMinutes,
                                            Principal principal,
                                            RedirectAttributes redirectAttributes) {
        try {
            User currentUser = userService.findUserByEmail(principal.getName());

            ProjectAssignment formAssignment = new ProjectAssignment();
            formAssignment.setSpentHours(spentHours);
            formAssignment.setSpentMinutes(spentMinutes);

            projectAssignmentService.finishProjectAssignment(id, formAssignment, currentUser.getId());

            redirectAttributes.addFlashAttribute("successMessage", "Завдання успішно завершено!");
            return "redirect:/developer/project-assignments";

        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("errorMessage", e.getMessage());
            return "redirect:/developer/project-assignments";
        }
    }


    //delete
    @PostMapping("/delete/{id}")
    public String deleteAssignment(@PathVariable Long id, RedirectAttributes redirectAttributes) {
        try {
            projectAssignmentService.deleteAssignment(id);
            redirectAttributes.addFlashAttribute("successMessage", "Завдання успішно видалено!");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("errorMessage", e.getMessage());
        }

        return "redirect:/admin/project-assignments";
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

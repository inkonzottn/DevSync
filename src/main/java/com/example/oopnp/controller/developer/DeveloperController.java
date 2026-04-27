package com.example.oopnp.controller.developer;

import com.example.oopnp.entity.Developer;
import com.example.oopnp.entity.User;
import com.example.oopnp.service.*;
import org.springframework.ui.Model;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;
import java.security.Principal;


@Controller
@RequiredArgsConstructor
@RequestMapping("/developer")
public class DeveloperController {

    private final UserService userService;
    private final CustomerService customerService;
    private final DeveloperService developerService;
    private final ProjectService projectService;
    private final ProjectAssignmentService projectAssignmentService;
    private final ManagerService managerService;


    // CUSTOMERS
    @GetMapping("/customers")
    public String getDeveloperCustomers(Principal principal, Model model) {
        User currentUser = userService.findUserByEmail(principal.getName());
        model.addAttribute("customers", customerService.findCustomersForDeveloper(currentUser.getId()));
        return "customers";
    }


    // DEVELOPERS
    @GetMapping("/developers")
    public String getPageDevelopers(Model model) {
        model.addAttribute("developers", developerService.findAllDevelopers());
        return "developers";
    }


    // MANAGERS
    @GetMapping("/managers")
    public String getMyManager(Principal principal, Model model) {
        User currentUser = userService.findUserByEmail(principal.getName());
        Developer currentDev = developerService.findByUserId(currentUser.getId());

        // якщо дев зараз на проєкті - показуємо його менеджера
        if (currentDev.getCurrentProject() != null) {
            model.addAttribute("managers",
                    managerService.getManagerWithActiveProjectsByUserId(currentDev.getCurrentProject().getManager().getUser().getId()));
        }

        return "managers";
    }

    // PROJECTS
    @GetMapping("/projects")
    public String getDeveloperProjects(Principal principal, Model model) {
        User currentUser = userService.findUserByEmail(principal.getName());
        model.addAttribute("projects", projectService.findProjectsForDeveloper(currentUser.getId()));
        return "projects";
    }

    // ASSIGNMENTS
    @GetMapping("/project-assignments")
    public String getDeveloperProjectAssignments(Principal principal, Model model) {
        User currentUser = userService.findUserByEmail(principal.getName());
        model.addAttribute("projectAssignments", projectAssignmentService.findAllTeamTasksByUserId(currentUser.getId()));

        Developer dev = developerService.findByUserId(currentUser.getId());
        model.addAttribute("hasActiveProject", dev.getCurrentProject() != null);

        return "project-assignments";
    }

}

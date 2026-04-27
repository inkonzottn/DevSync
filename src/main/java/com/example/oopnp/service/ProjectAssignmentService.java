package com.example.oopnp.service;

import com.example.oopnp.entity.Developer;
import com.example.oopnp.entity.Project;
import com.example.oopnp.entity.ProjectAssignment;
import com.example.oopnp.repository.DeveloperRepository;
import com.example.oopnp.repository.ProjectAssignmentRepository;
import com.example.oopnp.repository.ProjectRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.cache.annotation.CacheEvict;
import org.springframework.cache.annotation.Cacheable;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.List;

@Service
@RequiredArgsConstructor
public class ProjectAssignmentService {
    private final ProjectAssignmentRepository projectAssignmentRepository;
    private final DeveloperRepository developerRepository;
    private final ProjectRepository projectRepository;


    // save
    @Transactional
    @CacheEvict(value = "assignments", allEntries = true)
    public ProjectAssignment startProjectAssignment(ProjectAssignment projectAssignment, Long userId, Long projectId) {

        Developer developer = developerRepository.findByUserId(userId)
                .orElseThrow(() -> new IllegalArgumentException("Розробника з userId: " + userId + " не знайдено"));

        Project project = projectRepository.findById(projectId)
                .orElseThrow(() -> new IllegalArgumentException("Проєкт з id: " + projectId + " не знайдено"));

        projectAssignment.setProject(project);
        projectAssignment.setDeveloper(developer);
        projectAssignment.setActive(true);
        projectAssignment.setSpentHours(0);
        projectAssignment.setSpentMinutes(0);

        return projectAssignmentRepository.save(projectAssignment);
    }

    // update
    @Transactional
    @CacheEvict(value = "assignments", allEntries = true)
    public ProjectAssignment updateProjectAssignment(Long assignmentId, ProjectAssignment updatedAssignment, Long userId) {

        ProjectAssignment existingAssignment = projectAssignmentRepository.findById(assignmentId)
                .orElseThrow(() -> new IllegalArgumentException("Завдання з id " + assignmentId + " не знайдено"));

        if (!existingAssignment.getDeveloper().getUser().getId().equals(userId)) {
            throw new IllegalStateException("Ви не маєте прав на редагування чужого завдання!");
        }

        if (!existingAssignment.isActive()) {
            throw new IllegalStateException("Неможливо змінити вже завершене завдання. Зверніться до менеджера.");
        }

        existingAssignment.setTitle(updatedAssignment.getTitle());
        existingAssignment.setDescription(updatedAssignment.getDescription());

        return projectAssignmentRepository.save(existingAssignment);
    }

    // finish
    @Transactional
    @CacheEvict(value = "assignments", allEntries = true)
    public ProjectAssignment finishProjectAssignment(Long assignmentId, ProjectAssignment updatedAssignment, Long userId) {
        ProjectAssignment assignment = projectAssignmentRepository.findById(assignmentId)
                .orElseThrow(() -> new IllegalArgumentException("Завдання з id " + assignmentId + " не знайдено"));

        if (!assignment.getDeveloper().getUser().getId().equals(userId)) {
            throw new IllegalStateException("Ви не можете закрити чуже завдання!");
        }

        if (!assignment.isActive()) {
            throw new IllegalStateException("Це завдання вже було завершено раніше!");
        }

        assignment.setActive(false);
        assignment.setSpentHours(updatedAssignment.getSpentHours() != null ? updatedAssignment.getSpentHours() : 0);
        assignment.setSpentMinutes(updatedAssignment.getSpentMinutes() != null ? updatedAssignment.getSpentMinutes() : 0);
        assignment.setCompletedAt(LocalDateTime.now());

        return projectAssignmentRepository.save(assignment);
    }

    //delete
    @Transactional
    @CacheEvict(value = "assignments", allEntries = true)
    public void deleteAssignment(Long assignmentId) {
        if (!projectAssignmentRepository.existsById(assignmentId)) {
            throw new IllegalArgumentException("Завдання з id " + assignmentId + " не знайдено!");
        }

        projectAssignmentRepository.deleteById(assignmentId);
    }

    // find
    @Cacheable(value = "assignments", key = "'assign_' + #assignmentId")
    public ProjectAssignment findProjectAssignmentById(Long assignmentId) { return  projectAssignmentRepository.findById(assignmentId).get(); }

    @Cacheable(value = "assignments", key = "'all'")
    public List<ProjectAssignment> findAllProjectAssignments() {
        return projectAssignmentRepository.findAll();
    }

    @Cacheable(value = "assignments", key = "'by_project_' + #projectId")
    public List<ProjectAssignment> findAllProjectAssignmentsByProjectId(Long projectId) {
        return projectAssignmentRepository.findByProject_IdOrderByCreatedAtDesc(projectId);
    }

    @Cacheable(value = "assignments", key = "'team_tasks_' + #userId")
    public List<ProjectAssignment> findAllTeamTasksByUserId(Long userId) { return projectAssignmentRepository.findAllTeamTasksByUserId(userId); }

    @Cacheable(value = "assignments", key = "'manager_' + #userId")
    public List<ProjectAssignment> findProjectAssignmentsForManager(Long userId) {
        return projectAssignmentRepository.findByProject_Manager_User_IdOrderByCreatedAtDesc(userId);
    }

    @Cacheable(value = "assignments", key = "'customer_' + #userId")
    public List<ProjectAssignment> findProjectAssignmentsForCustomer(Long userId) {
        return projectAssignmentRepository.findByProject_Customer_User_IdOrderByCreatedAtDesc(userId);
    }

}

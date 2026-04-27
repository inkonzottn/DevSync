package com.example.oopnp.repository;

import com.example.oopnp.entity.ProjectAssignment;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.List;

public interface ProjectAssignmentRepository extends JpaRepository<ProjectAssignment, Long> {
    // отримати всі таски розробника
    List<ProjectAssignment> findByDeveloper_User_IdOrderByCreatedAtDesc(Long developerId);

    // отримати всі таски по проєкту, де призначений розробник
    @Query("SELECT pa FROM ProjectAssignment pa " +
            "JOIN FETCH pa.developer d " +
            "JOIN FETCH d.user " +
            "JOIN FETCH pa.project p " +
            "WHERE p.id = (SELECT dev.currentProject.id FROM Developer dev WHERE dev.user.id = :userId) " +
            "ORDER BY pa.createdAt DESC")
    List<ProjectAssignment> findAllTeamTasksByUserId(@Param("userId") Long userId);

    // отримати всі таски по проєкту
    List<ProjectAssignment> findByProject_IdOrderByCreatedAtDesc(Long projectId);

    // отримати всі таски по проєктам, де призначений менеджер
    List<ProjectAssignment> findByProject_Manager_User_IdOrderByCreatedAtDesc(Long managerId);

    // отримати всі таски по проєктам, де призначений замовник
    List<ProjectAssignment> findByProject_Customer_User_IdOrderByCreatedAtDesc(Long managerId);

    // чи є хоч один запис про роботу по цьому проєкту
    boolean existsByProjectId(Long projectId);

    // чи всі таски завершені
    boolean existsByProjectIdAndIsActiveTrue (Long projectId);

    // усі таски по проєкту
    List<ProjectAssignment> findByProjectId (Long  projectId);

}

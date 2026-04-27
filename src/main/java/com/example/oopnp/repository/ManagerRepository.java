package com.example.oopnp.repository;

import com.example.oopnp.entity.Manager;
import org.springframework.data.jpa.repository.EntityGraph;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.List;
import java.util.Optional;

public interface ManagerRepository extends JpaRepository<Manager, Long> {

    Manager findByAllProjects_Id(Long projectId);

    @EntityGraph(attributePaths = {"allProjects"})
    @Query("SELECT m FROM Manager m")
    List<Manager> findAllManagersWithProjects();

    @EntityGraph(attributePaths = {"allProjects"})
    @Query("SELECT m FROM Manager m WHERE m.user.id = :userId")
    Optional<Manager> findManagerWithProjectsByUserId(@Param("userId") Long userId);

}

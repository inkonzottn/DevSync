package com.example.oopnp.repository;

import com.example.oopnp.entity.Project;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.List;
import java.util.Optional;

public interface ProjectRepository extends JpaRepository<Project,Long> {

    Optional<Project> findById(Long id);

    // шукає проєкти, де customer.user.id == userId
    List<Project> findByCustomer_User_Id(Long userId);

    //  шукає проєкти, де manager.user.id == userId
    List<Project> findByManager_User_Id(Long userId);

    // якщо в класі Project є список девів (List<Developer> developers)
    List<Project> findByDevelopers_User_Id(Long userId);


    @Query("SELECT p FROM Project p ORDER BY " +
            "CASE p.status " +
            "WHEN 'PROPOSAL' THEN 1 " +
            "WHEN 'IN_PROGRESS' THEN 2 " +
            "WHEN 'COMPLETED' THEN 3 " +
            "WHEN 'INVOICED' THEN 4 " +
            "WHEN 'CLOSED' THEN 5 " +
            "ELSE 6 END ASC, " +
            "p.createdAt DESC")
    List<Project> findAllProjectsSortedByStatus();

    @Query("SELECT p FROM Project p WHERE p.manager.user.id = :userId ORDER BY " +
            "CASE p.status " +
            "WHEN 'PROPOSAL' THEN 1 " +
            "WHEN 'IN_PROGRESS' THEN 2 " +
            "WHEN 'COMPLETED' THEN 3 " +
            "WHEN 'INVOICED' THEN 4 " +
            "WHEN 'CLOSED' THEN 5 " +
            "ELSE 6 END ASC, " +
            "p.createdAt DESC")
    List<Project> findProjectsForManagerSortedByStatus(@Param("userId") Long userId);

    @Query("SELECT DISTINCT p FROM Project p JOIN p.developers d WHERE d.user.id = :userId ORDER BY " +
            "CASE p.status " +
            "WHEN 'PROPOSAL' THEN 1 " +
            "WHEN 'IN_PROGRESS' THEN 2 " +
            "WHEN 'COMPLETED' THEN 3 " +
            "WHEN 'INVOICED' THEN 4 " +
            "WHEN 'CLOSED' THEN 5 " +
            "ELSE 6 END ASC, " +
            "p.createdAt DESC")
    List<Project> findProjectsForDeveloperSortedByStatus(@Param("userId") Long userId);


    @Query("SELECT p FROM Project p WHERE p.customer.user.id = :userId ORDER BY " +
            "CASE p.status " +
            "WHEN 'PROPOSAL' THEN 1 " +
            "WHEN 'IN_PROGRESS' THEN 2 " +
            "WHEN 'COMPLETED' THEN 3 " +
            "WHEN 'INVOICED' THEN 4 " +
            "WHEN 'CLOSED' THEN 5 " +
            "ELSE 6 END ASC, " +
            "p.createdAt DESC")
    List<Project> findProjectsForCustomerSortedByStatus(@Param("userId") Long userId);


    // проєкти, де є хоча б один інвойс.
    @Query("SELECT DISTINCT p FROM Project p JOIN FETCH p.invoices i " +
            "ORDER BY p.createdAt DESC, i.createdAt DESC")
    List<Project> findProjectsWithInvoices();


    // проєкти, де є хоча б один інвойс для менеджера
    @Query("SELECT DISTINCT p FROM Project p JOIN FETCH p.invoices i " +
            "WHERE p.manager.user.id = :userId " +
            "ORDER BY p.createdAt DESC, i.createdAt DESC")
    List<Project> findProjectsWithInvoicesByManager(@Param("userId") Long userId);


    // проєкти, де є хоча б один інвойс для замовника
    @Query("SELECT DISTINCT p FROM Project p JOIN FETCH p.invoices i " +
            "WHERE p.customer.user.id = :userId " +
            "ORDER BY p.createdAt DESC, i.createdAt DESC")
    List<Project> findProjectsWithInvoicesByCustomer(@Param("userId") Long userId);
}

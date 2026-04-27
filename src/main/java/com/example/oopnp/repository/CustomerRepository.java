package com.example.oopnp.repository;

import com.example.oopnp.entity.Customer;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;

import java.util.List;
import java.util.Optional;

public interface CustomerRepository extends JpaRepository<Customer, Long> {
    Customer findByUserFirstName(String firstName);

    Optional<Customer> findByUserId(Long userId);

    // шукає замовників, де призначений конкретний розробник
    List<Customer> findByProjects_Developers_User_Id(Long userId);

    //  шукає проєкти, де призначений конкретний менеджер
    List<Customer> findByProjects_Manager_User_Id(Long userId);

    @Query("SELECT DISTINCT c FROM Customer c " +
            "LEFT JOIN FETCH c.projects p " +
            "ORDER BY c.id ASC, " +
            "CASE p.status " +
            "WHEN 'PROPOSAL' THEN 1 " +
            "WHEN 'IN_PROGRESS' THEN 2 " +
            "WHEN 'COMPLETED' THEN 3 " +
            "WHEN 'INVOICED' THEN 4 " +
            "WHEN 'CLOSED' THEN 5 " +
            "ELSE 6 END ASC, " +
            "p.createdAt DESC")
    List<Customer> findAllCustomersWithSortedProjects();

}

package com.example.oopnp.repository;

import com.example.oopnp.entity.Invoice;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface InvoiceRepository extends JpaRepository<Invoice, Long> {

    // шукає рахунки, де project.customer.user.id == userId
    List<Invoice> findByProject_Customer_User_Id(Long userId);

    //  шукає рахунки, де project.manager.user.id == userId
    List<Invoice> findByProject_Manager_User_Id(Long userId);

}

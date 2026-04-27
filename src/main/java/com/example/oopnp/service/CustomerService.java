package com.example.oopnp.service;

import com.example.oopnp.entity.Customer;
import com.example.oopnp.repository.CustomerRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.cache.annotation.CacheEvict;
import org.springframework.cache.annotation.Cacheable;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
@RequiredArgsConstructor
public class CustomerService {

    private final CustomerRepository customerRepository;

    //delete
    @Transactional
    @CacheEvict(value = "customers", allEntries = true)
    public void deleteCustomerById(Long id) {

        Customer customer = customerRepository.findById(id)
                .orElseThrow(() -> new IllegalArgumentException("Замовника з ID " + id + " не знайдено"));

        customerRepository.delete(customer);
    }

    // find
    @Cacheable(value = "customers", key = "'all'")
    public List<Customer> findAllCustomers() {
        return customerRepository.findAll();
    }

    @Cacheable(value = "customers", key = "'all_with_projects'")
    public List<Customer> findAllCustomersWithSortedProjects() { return  customerRepository.findAllCustomersWithSortedProjects(); }

    @Cacheable(value = "customers", key = "'manager_' + #userId")
    public List<Customer> findCustomersForManager(Long userId) {
        return customerRepository.findByProjects_Manager_User_Id(userId);
    }

    @Cacheable(value = "customers", key = "'dev_' + #userId")
    public List<Customer> findCustomersForDeveloper(Long userId) {
        return customerRepository.findByProjects_Developers_User_Id(userId);
    }

}

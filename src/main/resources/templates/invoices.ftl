<!DOCTYPE html>
<html lang="uk">
<head>
    <meta charset="UTF-8">
    <title>Рахунки | DevSync</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <link rel="stylesheet" href="/css/style.css">
    <style>
        /* Залізобетонний сайдбар та контент */
        .sidebar { flex-shrink: 0 !important; }
        .main-content { min-width: 0; overflow-x: hidden; }
        /* Клікабельна картка інвойсу */
        .invoice-card { transition: transform 0.2s ease, box-shadow 0.2s ease; cursor: pointer; }
        .invoice-card:hover { transform: translateY(-3px); box-shadow: 0 .5rem 1rem rgba(0,0,0,.08) !important; }
    </style>
</head>
<body class="d-flex bg-light">

<#include "sidebar.ftl">

<div class="main-content flex-grow-1 p-4" style="min-width: 0;">
    <div class="container-fluid" style="max-width: 1200px;">

        <div class="d-flex flex-column flex-sm-row justify-content-between align-items-start align-items-sm-center gap-3 mb-4">
            <div>
                <h2 class="fw-bold m-0 text-dark">Рахунки</h2>
                <p class="text-muted small mb-0 mt-1">Фінансові документи та статус оплат по проєктах</p>
            </div>
        </div>

        <#if successMessage??>
            <div class="alert alert-success alert-dismissible fade show shadow-sm border-0 rounded-4" role="alert">
                <i class="bi bi-check-circle-fill me-2"></i>${successMessage}
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        </#if>
        <#if errorMessage??>
            <div class="alert alert-danger alert-dismissible fade show shadow-sm border-0 rounded-4" role="alert">
                <i class="bi bi-exclamation-triangle-fill me-2"></i>${errorMessage}
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        </#if>

        <#if projectsWithInvoices?? && projectsWithInvoices?has_content>

            <#list projectsWithInvoices as proj>
                <div class="mb-4 bg-white p-4 rounded-4 shadow-sm border">

                    <div class="mb-4 pb-3 border-bottom">
                        <div class="fw-bold text-dark d-flex align-items-center gap-2 mb-2" style="font-size: 1.1rem;">
                            <i class="bi bi-folder2-open text-primary"></i> ${proj.title}
                        </div>
                        <div class="d-flex flex-wrap gap-4 text-muted small">
                            <span><i class="bi bi-building me-1"></i> <span class="fw-medium">${proj.customer.companyName}</span> (${proj.customer.user.firstName} ${proj.customer.user.lastName})</span>
                            <#if proj.manager??>
                                <span><i class="bi bi-person-badge me-1"></i> Менеджер: ${proj.manager.user.firstName} ${proj.manager.user.lastName}</span>
                            </#if>
                        </div>
                    </div>

                    <div class="row g-3">
                        <#list proj.invoices as invoice>
                            <div class="col-12 col-md-6 col-xl-4">

                                <div class="card invoice-card h-100 border-0 border-start border-4 <#if invoice.status == 'PAID'>border-success<#elseif invoice.status == 'CANCELLED'>border-danger<#else>border-warning</#if> shadow-sm bg-light rounded-3"
                                     onclick="window.location.href='/invoices/${invoice.id}'">

                                    <div class="card-body p-3 d-flex flex-column">

                                        <div class="d-flex justify-content-between align-items-start mb-2">
                                            <span class="text-muted fw-bold" style="font-size: 0.8rem; letter-spacing: 0.5px;">
                                                РАХУНОК #${invoice.id}
                                            </span>

                                            <div class="d-flex align-items-center gap-2">
                                                <#if invoice.status == "CANCELLED">
                                                    <span class="badge bg-danger bg-opacity-10 text-danger border border-danger-subtle rounded-pill px-2 py-1" style="font-size: 0.7rem;">Відхилено</span>
                                                <#elseif invoice.status == "PAID">
                                                    <span class="badge bg-success bg-opacity-10 text-success border border-success-subtle rounded-pill px-2 py-1" style="font-size: 0.7rem;">Оплачено</span>
                                                <#elseif invoice.status == "PENDING">
                                                    <span class="badge bg-warning bg-opacity-10 text-dark border border-warning-subtle rounded-pill px-2 py-1" style="font-size: 0.7rem;">В очікуванні</span>
                                                </#if>

                                                <#if isAuth?? && (isAdmin?? && isAdmin) || (isManager?? && isManager)>
                                                    <div class="dropdown">
                                                        <button class="btn btn-sm rounded-circle border bg-white d-flex align-items-center justify-content-center"
                                                                type="button" data-bs-toggle="dropdown"
                                                                style="width: 28px; height: 28px; padding: 0;"
                                                                onclick="event.stopPropagation();">
                                                            <i class="bi bi-three-dots-vertical text-muted" style="font-size: 0.8rem;"></i>
                                                        </button>
                                                        <ul class="dropdown-menu dropdown-menu-end shadow-sm border-0 rounded-4 mt-1">
                                                            <li>
                                                                <a class="dropdown-item d-flex align-items-center gap-2 py-2 fw-medium"
                                                                   href="/invoices/edit/${invoice.id}"
                                                                   onclick="event.stopPropagation();">
                                                                    <i class="bi bi-pencil-fill text-warning"></i> Редагувати
                                                                </a>
                                                            </li>
                                                        </ul>
                                                    </div>
                                                </#if>
                                            </div>
                                        </div>

                                        <div class="my-2 flex-grow-1">
                                            <div class="fw-bold text-dark fs-4 lh-1">
                                                ${invoice.finalPrice?string("0.00")} <span style="font-size: 1rem;" class="text-secondary fw-medium">грн</span>
                                            </div>
                                        </div>

                                        <div class="mt-auto border-top border-secondary-subtle pt-2">

                                            <div class="d-flex justify-content-between align-items-center mb-1">
                                                <div class="text-muted" style="font-size: 0.75rem;">
                                                    <i class="bi bi-calendar-event me-1"></i>Виставлено:
                                                </div>
                                                <div class="fw-medium text-dark" style="font-size: 0.8rem;">
                                                    ${invoice.getFormattedCreatedAt()}
                                                </div>
                                            </div>

                                            <div class="d-flex justify-content-between align-items-center">
                                                <#if invoice.completedAt??>
                                                    <div class="text-muted" style="font-size: 0.75rem;">
                                                        <i class="bi bi-calendar-check-fill text-muted me-1"></i>Оплачено:
                                                    </div>
                                                    <div class="fw-medium text-dark" style="font-size: 0.8rem;">
                                                        ${invoice.getFormattedCompletedAt()}
                                                    </div>
                                                <#else>
                                                    <div class="text-muted" style="font-size: 0.75rem;">
                                                        <i class="bi bi-hourglass-split me-1"></i>Статус:
                                                    </div>
                                                    <div class="text-muted fw-medium" style="font-size: 0.8rem;">
                                                        Не оплачено
                                                    </div>
                                                </#if>
                                            </div>

                                        </div>
                                    </div>
                                </div>
                            </div>
                        </#list>
                    </div>
                </div>
            </#list>

        <#else>
            <div class="col-12 text-center py-5 bg-white rounded-4 shadow-sm border mt-2">
                <i class="bi bi-receipt-cutoff text-secondary opacity-25" style="font-size: 3rem;"></i>
                <h5 class="fw-medium text-dark mt-3" style="font-size: 1.1rem;">Немає жодних рахунків</h5>
                <p class="text-muted small mt-1 mb-0">Тут відображатимуться фінансові документи по проєктах.</p>
            </div>
        </#if>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
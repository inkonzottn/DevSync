<!DOCTYPE html>
<html lang="uk">
<head>
    <meta charset="UTF-8">
    <title>Проєкти | DevSync</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <link rel="stylesheet" href="/css/style.css">
    <style>
        .sidebar { flex-shrink: 0 !important; }
        .main-content { min-width: 0; overflow-x: hidden; }
    </style>
</head>
<body class="d-flex bg-light">

<#include "sidebar.ftl">

<div class="main-content flex-grow-1 p-4">
    <div class="container-fluid" style="max-width: 1200px;">

        <div class="d-flex flex-column flex-sm-row justify-content-between align-items-start align-items-sm-center gap-3 mb-4">
            <div>
                <h2 class="fw-bold m-0 text-dark">Проєкти</h2>
            </div>

            <#if isAuth?? && (isCustomer?? && isCustomer)>
                <a href="/${rolePath}/projects/create"
                   class="btn btn-primary rounded-pill px-4 shadow-sm d-flex align-items-center gap-2 fw-medium">
                    <i class="bi bi-plus-lg"></i> Оформити заявку
                </a>
            </#if>
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

        <div class="row g-4">
            <#if projects?has_content>
                <#list projects as project>
                    <div class="col-12 col-lg-6">
                        <div class="card h-100 shadow-sm border rounded-4 p-4">

                            <div class="d-flex justify-content-between align-items-start gap-3 mb-3">
                                <div>
                                    <div class="d-flex align-items-center gap-2 mb-1">
                                        <h5 class="fw-bold text-dark m-0">${project.title}</h5>
                                    </div>
                                    <div class="text-muted small">
                                        <i class="bi bi-building me-1"></i> <span class="fw-medium">${project.customer.companyName}</span>
                                        <span class="d-inline-block">(${project.customer.user.firstName} ${project.customer.user.lastName})</span>
                                    </div>
                                </div>
                                <div>
                                    <#if project.status == "PROPOSAL">
                                        <span class="badge rounded-pill bg-warning text-dark px-3 py-2 fw-medium">На розгляді</span>
                                    <#elseif project.status == "IN_PROGRESS">
                                        <span class="badge rounded-pill bg-primary px-3 py-2 fw-medium">В процесі</span>
                                    <#elseif project.status == "COMPLETED">
                                        <span class="badge rounded-pill bg-success px-3 py-2 fw-medium">Завершено</span>
                                    <#elseif project.status == "INVOICED">
                                        <span class="badge rounded-pill bg-info text-dark px-3 py-2 fw-medium">Виставлено рахунок</span>
                                    <#elseif project.status == "CLOSED">
                                        <span class="badge rounded-pill bg-info px-3 py-2 fw-medium">Закрито</span>
                                    <#else>
                                        <span class="badge rounded-pill bg-secondary px-3 py-2 fw-medium">${project.status}</span>
                                    </#if>
                                </div>
                            </div>

                            <p class="text-secondary small mb-4" style="display: -webkit-box; -webkit-line-clamp: 2; -webkit-box-orient: vertical; overflow: hidden;">
                                <#if project.description?has_content>
                                    ${project.description}
                                <#else>
                                    <span class="text-muted fst-italic">Опис відсутній</span>
                                </#if>
                            </p>

                            <div class="row g-3 mb-4 bg-light rounded-3 p-3 mx-0">
                                <div class="col-12 col-sm-6">
                                    <div class="small text-uppercase text-secondary fw-bold mb-1" style="font-size: 0.75rem;"><i class="bi bi-calendar-plus me-1"></i> Створено</div>
                                    <div class="fw-medium text-dark">
                                        <#if project.createdAt??>
                                            ${project.getFormattedCreatedAt()}
                                        <#else>
                                            —
                                        </#if>
                                    </div>
                                </div>
                                <div class="col-12 col-sm-6">
                                    <div class="small text-uppercase text-secondary fw-bold mb-1" style="font-size: 0.75rem;"><i class="bi bi-calendar-check me-1"></i> Закрито</div>
                                    <div class="fw-medium text-dark">
                                        <#if project.closedAt??>
                                            ${project.getFormattedCompletedAt()}
                                        <#else>
                                            <span class="text-success small fw-semibold"><i class="bi bi-record-circle"></i> Активний</span>
                                        </#if>
                                    </div>
                                </div>

                                <div class="col-12 col-sm-6">
                                    <div class="small text-uppercase text-secondary fw-bold mb-1" style="font-size: 0.75rem;"><i class="bi bi-person-badge me-1"></i> Менеджер</div>
                                    <div class="fw-medium text-dark">
                                        <#if project.manager??>
                                            ${project.manager.user.firstName} ${project.manager.user.lastName}
                                        <#else>
                                            <span class="text-danger small fw-semibold">Не призначено</span>
                                        </#if>
                                    </div>
                                </div>

                                <div class="col-12 col-sm-6">
                                    <div class="small text-uppercase text-secondary fw-bold mb-1" style="font-size: 0.75rem;"><i class="bi bi-code-slash me-1"></i> Розробники</div>
                                    <div class="d-flex flex-wrap gap-1 mt-1">
                                        <#if project.developers?? && project.developers?has_content>
                                            <#list project.developers as dev>
                                                <span class="badge bg-white border text-secondary fw-medium px-2 py-1">${dev.user.firstName} ${dev.user.lastName}</span>
                                            </#list>
                                        <#else>
                                            <span class="text-muted small fw-medium">Команда не сформована</span>
                                        </#if>
                                    </div>
                                </div>
                            </div>

                            <div class="d-flex justify-content-between align-items-center mt-auto pt-3 border-top">
                                <div class="d-flex flex-wrap gap-2">
                                    <#if project.invoices?? && project.invoices?has_content>
                                        <#list project.invoices as inv>
                                            <div class="badge bg-white border px-2 py-1 <#if inv.status == 'PAID'>border-success text-success<#elseif inv.status == 'CANCELLED'>border-danger text-danger<#else>border-warning text-dark</#if>">
                                                <i class="bi bi-receipt me-1"></i> ${inv.finalPrice?string("0.00")} грн
                                                <#if inv.status == "PENDING">
                                                    <span class="ms-1 opacity-75 fw-normal">(Виставлено рахунок)</span>
                                                    <#elseif inv.status == "PAID">
                                                        <span class="ms-1 opacity-75 fw-normal">(Оплачено)</span>
                                                    <#elseif inv.status == "CANCELLED">
                                                        <span class="ms-1 opacity-75 fw-normal">(Відхилено)</span>
                                                </#if>
                                            </div>
                                        </#list>
                                    <#else>
                                        <span class="text-muted small fw-medium"><i class="bi bi-receipt-cutoff me-1"></i> Рахунків немає</span>
                                    </#if>
                                </div>

                                <#if isAuth?? && (isAdmin?? && isAdmin) || (isManager?? && isManager)>
                                    <div class="dropdown">
                                        <button class="btn btn-light btn-sm rounded-circle border shadow-sm d-flex align-items-center justify-content-center" type="button" data-bs-toggle="dropdown" style="width: 32px; height: 32px;">
                                            <i class="bi bi-three-dots-vertical"></i>
                                        </button>
                                        <ul class="dropdown-menu dropdown-menu-end shadow border-0 rounded-4 mt-2">
                                            <li>
                                                <a class="dropdown-item d-flex align-items-center gap-2 py-2 fw-medium" href="/${rolePath}/projects/edit/${project.id}">
                                                    <i class="bi bi-pencil-fill text-warning"></i> Редагувати
                                                </a>
                                            </li>
                                            <#if project.status == "INVOICED" || project.status == "COMPLETED">
                                                <li><hr class="dropdown-divider"></li>
                                                <li>
                                                    <a class="dropdown-item d-flex align-items-center gap-2 py-2 fw-medium" href="/invoices/create/${project.id}">
                                                        <i class="bi bi-cash-coin text-success"></i> Виставити рахунок
                                                    </a>
                                                </li>
                                            </#if>
                                            <li><hr class="dropdown-divider"></li>
                                            <li>
                                                <form action="/admin/projects/delete/${project.id}" method="post"
                                                      onsubmit="return confirm('Ви впевнені? Проєкт буде видалено зі списків усіх розробників. Цю дію неможливо скасувати!');"
                                                      style="display:inline;">
                                                    <button type="submit" class="dropdown-item text-danger d-flex align-items-center gap-2 py-2 fw-medium">
                                                        <i class="bi bi-trash3"></i> Видалити
                                                    </button>
                                                </form>
                                            </li>
                                        </ul>
                                    </div>
                                </#if>
                            </div>

                        </div>
                    </div>
                </#list>
            <#else>
                <div class="col-12 text-center py-5">
                    <div class="text-muted mb-3"><i class="bi bi-folder-x" style="font-size: 3rem; opacity: 0.5;"></i></div>
                    <h5 class="fw-medium text-secondary">Немає жодних проєктів</h5>
                    <p class="text-muted small">Коли з'являться нові заявки, вони відобразяться тут.</p>
                </div>
            </#if>
        </div>

    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
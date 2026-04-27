<!DOCTYPE html>
<html lang="uk">
<head>
    <meta charset="UTF-8">
    <title>Редагування рахунку | DevSync</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <link rel="stylesheet" href="/css/style.css">
    <style>
        body { background-color: #f8f9fa; }
        .invoice-card { max-width: 600px; margin: 0 auto; border: none; border-radius: 15px; box-shadow: 0 10px 30px rgba(0,0,0,0.08); overflow: hidden; }
        .invoice-header-edit { background: linear-gradient(135deg, #e67e22, #f39c12); color: white; padding: 30px; }
    </style>
</head>
<body class="d-flex">

<#include "sidebar.ftl">

<div class="main-content flex-grow-1 p-4">
    <div class="container py-4">

        <div class="d-flex align-items-center mb-4 justify-content-center" style="max-width: 600px; margin: 0 auto;">
            <a href="javascript:history.back()" class="btn btn-light rounded-circle me-auto shadow-sm"><i class="bi bi-arrow-left"></i></a>
            <h3 class="fw-bold m-0 pe-5">Коригування інвойсу</h3>
        </div>

        <#if errorMessage??>
            <div class="alert alert-danger mx-auto shadow-sm d-flex align-items-center" style="max-width: 600px;">
                <i class="bi bi-exclamation-triangle-fill me-2 fs-5"></i>
                <div>${errorMessage}</div>
            </div>
        </#if>

        <div class="card invoice-card">
            <div class="invoice-header-edit text-center">
                <i class="bi bi-pencil-square fs-1 d-block mb-2 opacity-75"></i>
                <h4 class="mb-0 fw-bold">Рахунок #${invoice.id}</h4>
                <p class="text-white-50 mb-0 mt-1">Проєкт: ${invoice.project.title}</p>
            </div>

            <div class="card-body p-4 p-md-5 bg-white">
                <div class="mb-4 pb-4 border-bottom">
                    <p class="text-uppercase text-muted fw-bold mb-3 small tracking-wide">Поточні дані</p>

                    <div class="d-flex justify-content-between align-items-center mb-2">
                        <div class="text-secondary fw-medium">Собівартість (мінімум):</div>
                        <div class="fw-bold fs-6 text-dark">$${invoice.devCosts?string("0.00")}</div>
                    </div>
                    <div class="d-flex justify-content-between align-items-center">
                        <div class="text-secondary fw-medium">Статус:</div>
                        <span class="badge bg-warning text-dark border border-warning-subtle">${invoice.status}</span>
                    </div>
                </div>

                <form action="/invoices/edit/${invoice.id}" method="post">

                    <label class="form-label text-uppercase text-muted fw-bold small tracking-wide mb-3">Оновлена сума до сплати ($)</label>
                    <div class="input-group input-group-lg mb-4 shadow-sm">
                        <span class="input-group-text bg-light text-warning-emphasis fw-bold border-warning border-opacity-50"><i class="bi bi-currency-dollar"></i></span>
                        <input type="number" step="0.01" name="finalPrice"
                               class="form-control text-dark fw-bold border-warning border-opacity-50"
                               style="font-size: 1.5rem;"
                               min="${invoice.devCosts?string('0.##')?replace(',', '.')}"
                               value="${invoice.finalPrice?string('0.##')?replace(',', '.')}"
                               required>
                    </div>

                    <label class="form-label text-uppercase text-muted fw-bold small tracking-wide mb-3">Дія з рахунком</label>
                    <select name="status" class="form-select form-select-lg mb-4 shadow-sm border-warning border-opacity-50 fw-bold">
                        <option value="PENDING" <#if invoice.status == 'PENDING'>selected</#if>>Очікує оплати (PENDING)</option>
                        <option value="CANCELLED" <#if invoice.status == 'CANCELLED'>selected</#if> class="text-danger">Анулювати рахунок (CANCELLED)</option>
                    </select>

                    <div class="form-text mb-4 text-muted"><i class="bi bi-info-circle me-1"></i>Зміна суми не впливає на зарплати розробників.</div>

                    <div class="d-flex gap-2">
                        <a href="javascript:history.back()" class="btn btn-light btn-lg w-50 fw-medium border">Скасувати</a>
                        <button type="submit" class="btn btn-warning btn-lg w-50 shadow fw-bold">
                            <i class="bi bi-floppy-fill me-2"></i> Зберегти
                        </button>
                    </div>
                </form>
            </div>
        </div>

    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
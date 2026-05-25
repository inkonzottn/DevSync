<!DOCTYPE html>
<html lang="uk">
<head>
    <meta charset="UTF-8">
    <title>Рахунок #${invoice.id} | DevSync</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <link rel="stylesheet" href="/css/style.css">
    <style>
        body { background-color: #f8f9fa; }
        .receipt-card { max-width: 800px; margin: 0 auto; background: #fff; border-radius: 10px; box-shadow: 0 4px 20px rgba(0,0,0,0.05); }
        .receipt-header { border-bottom: 2px solid #eee; padding-bottom: 20px; margin-bottom: 20px; }

        @media print {
            body { background-color: #fff; }
            .sidebar, .btn, .no-print { display: none !important; }
            .main-content { margin-left: 0 !important; padding: 0 !important; }
            .receipt-card { box-shadow: none; max-width: 100%; border: none; }
        }
    </style>
</head>
<body class="d-flex">

<div class="main-content flex-grow-1 p-4">
    <div class="container py-4">

        <div class="d-flex justify-content-between align-items-center mb-4 no-print" style="max-width: 800px; margin: 0 auto;">
            <a href="javascript:history.back()" class="btn btn-light border"><i class="bi bi-arrow-left"></i> Назад</a>
            <button onclick="window.print()" class="btn btn-outline-secondary"><i class="bi bi-file-earmark-pdf"></i> Завантажити PDF</button>
        </div>

        <div class="receipt-card p-5">
            <div class="receipt-header d-flex justify-content-between align-items-end">
                <div>
                    <h2 class="fw-bold mb-0">РАХУНОК #${invoice.id}</h2>
                    <p class="text-muted mb-0">Дата: ${.now?string('dd.MM.yyyy')}</p>
                </div>
                <div class="text-end">
                    <h4 class="fw-bold text-primary mb-0">DevSync Agency</h4>
                    <p class="text-muted small mb-0">Проєкт: ${invoice.project.title}</p>
                </div>
            </div>

            <h5 class="fw-bold mb-3 mt-4">Деталізація виконаних робіт</h5>
            <div class="table-responsive mb-4">
                <table class="table table-bordered align-middle">
                    <thead class="table-light text-muted small text-uppercase">
                    <tr>
                        <th>Розробник</th>
                        <th>Завдання</th>
                        <th class="text-center">Витрачений час</th>
                    </tr>
                    </thead>
                    <tbody>
                    <#if tasks?? && tasks?size gt 0>
                        <#list tasks as task>
                            <tr>
                                <td class="fw-medium">${task.developer.user.firstName} ${task.developer.user.lastName}</td>
                                <td>${task.title!"Виконання завдання по проєкту"}</td>
                                <td class="text-center">${task.spentHours} год ${task.spentMinutes} хв</td>
                            </tr>
                        </#list>
                    <#else>
                        <tr><td colspan="3" class="text-center text-muted py-3">Немає деталізації завдань</td></tr>
                    </#if>
                    </tbody>
                </table>
            </div>

            <div class="row align-items-center bg-light p-4 rounded-3 border">
                <div class="col-md-6">
                    <p class="text-muted small text-uppercase mb-1">Статус рахунку</p>
                    <#if invoice.status == 'PENDING'>
                        <span class="badge bg-warning text-dark fs-6 border border-warning-subtle py-2 px-3">ОЧІКУЄ ОПЛАТИ</span>
                    <#elseif invoice.status == 'PAID'>
                        <span class="badge bg-success fs-6 py-2 px-3"><i class="bi bi-check-circle me-1"></i> ОПЛАЧЕНО</span>
                    <#elseif invoice.status == 'CANCELLED'>
                        <span class="badge bg-danger fs-6 py-2 px-3">АНУЛЬОВАНО</span>
                    </#if>
                </div>
                <div class="col-md-6 text-end">
                    <p class="text-muted small text-uppercase mb-1">Загальна сума до сплати</p>

                    <div class="my-2 flex-grow-1">
                        <div class="fw-bold text-dark fs-5 lh-1">
                            ${invoice.finalPrice?string("0.00")} <span style="font-size: 1rem;" class="text-secondary fw-medium">грн</span>
                        </div>
                    </div>
                </div>
            </div>

            <#if invoice.status == 'PENDING' && (isAuth?? && (isCustomer?? && isCustomer)) >
                <div class="mt-5 text-center no-print">
                    <form action="/customer/invoices/${invoice.id}/pay" method="post" onsubmit="return confirm('Ви підтверджуєте оплату рахунку на суму $${invoice.finalPrice?string("0.00")}?');">
                        <button type="submit" class="btn btn-success btn-lg px-5 py-3 fw-bold shadow">
                            <i class="bi bi-credit-card me-2"></i> Оплатити рахунок
                        </button>
                    </form>
                </div>
            </#if>

        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
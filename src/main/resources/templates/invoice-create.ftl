<!DOCTYPE html>
<html lang="uk">
<head>
    <meta charset="UTF-8">
    <title>Виставлення рахунку | DevSync</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <link rel="stylesheet" href="/css/style.css">
    <style>
        body { background-color: #f8f9fa; }
        .invoice-card { max-width: 600px; margin: 0 auto; border: none; border-radius: 15px; box-shadow: 0 10px 30px rgba(0,0,0,0.08); overflow: hidden; }
        .invoice-header { background: linear-gradient(135deg, #2c3e50, #3498db); color: white; padding: 30px; }
        .money-display { font-size: 2.5rem; font-weight: 800; color: #198754; letter-spacing: -1px; }
    </style>
</head>
<body class="d-flex">

<div class="main-content flex-grow-1 p-4">
    <div class="container py-4">

        <div class="d-flex align-items-center mb-4 justify-content-center" style="max-width: 600px; margin: 0 auto;">
            <a href="/${rolePath}/projects" class="btn btn-light rounded-circle me-auto shadow-sm"><i class="bi bi-arrow-left"></i></a>
            <h3 class="fw-bold m-0 pe-5">Генерація рахунку</h3>
        </div>

        <#if errorMessage??>
            <div class="alert alert-danger mx-auto shadow-sm" style="max-width: 600px;">
                <i class="bi bi-exclamation-triangle-fill me-2"></i>${errorMessage}
            </div>
        </#if>

        <div class="card invoice-card">
            <div class="invoice-header text-center">
                <i class="bi bi-receipt fs-1 d-block mb-2 opacity-75"></i>
                <h4 class="mb-0 fw-bold">Проєкт: ${project.title}</h4>
                <p class="text-white-50 mb-0 mt-1">Замовник: ${project.customer.companyName!"Не вказано"}</p>
            </div>

            <div class="card-body p-4 p-md-5 bg-white">
                <div class="mb-5 pb-4 border-bottom">
                    <p class="text-uppercase text-muted fw-bold mb-3 small tracking-wide">Фінансова аналітика</p>

                    <div class="d-flex justify-content-between align-items-end mb-2">
                        <div class="text-secondary fw-medium">Собівартість робіт (ЗП розробників):</div>
                        <div class="fw-bold fs-5 text-dark">$${devCosts?string("0.00")}</div>
                    </div>

                    <div class="alert alert-info bg-info bg-opacity-10 border-info border-opacity-25 mt-3 small">
                        <i class="bi bi-info-circle-fill me-2"></i>
                        Це мінімальна сума для покриття витрат на зарплати. Ви повинні додати свою маржу (офіс, менеджмент, прибуток компанії).
                    </div>
                </div>

                <form action="/invoices/create/${project.id}" method="post">
                    <label class="form-label text-uppercase text-muted fw-bold small tracking-wide mb-3">Фінальна сума до сплати ($)</label>

                    <div class="input-group input-group-lg mb-4 shadow-sm">
                        <span class="input-group-text bg-light text-success fw-bold border-success border-opacity-50"><i class="bi bi-currency-dollar"></i></span>
                        <input type="number" step="0.01" name="finalPrice"
                               class="form-control text-success fw-bold border-success border-opacity-50"
                               style="font-size: 1.5rem;"
                               min="${devCosts?string('0.##')?replace(',', '.')}"
                               value="${(devCosts * 1.3)?string('0.##')?replace(',', '.')}"
                               required>
                    </div>
                    <div class="form-text mb-4">Автоматично запропоновано суму з націнкою 30%. Ви можете змінити її.</div>

                    <button type="submit" class="btn btn-success btn-lg w-100 shadow fw-bold">
                        <i class="bi bi-send-check me-2"></i> Згенерувати та виставити рахунок
                    </button>
                </form>
            </div>
        </div>

    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
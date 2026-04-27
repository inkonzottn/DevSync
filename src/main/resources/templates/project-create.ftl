<!DOCTYPE html>
<html lang="uk">
<head>
    <meta charset="UTF-8">
    <title>Новий проєкт | DevSync</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">
    <style>
        body { background-color: #f8f9fa; font-family: 'Inter', sans-serif; }
        .card { border: none; border-radius: 15px; box-shadow: 0 4px 20px rgba(0,0,0,0.05); }
        .form-label { font-weight: 600; color: #495057; }
        .btn-save { background: #0d6efd; color: white; border-radius: 10px; padding: 10px 25px; }
    </style>
</head>
<body class="d-flex">

<div class="main-content flex-grow-1 p-4">
    <div class="container">
        <div class="row justify-content-center">
            <div class="col-md-8">
                <div class="d-flex align-items-center mb-4">
                    <a href="/customer/projects" class="btn btn-light rounded-circle me-3">
                        <i class="bi bi-arrow-left"></i>
                    </a>
                    <h2 class="fw-bold m-0">Оформити нову заявку</h2>
                </div>

                <div class="card p-4">
                    <form action="/customer/projects/create" method="post">

                        <div class="mb-4">
                            <label class="form-label">Назва проєкту</label>
                            <input type="text" name="title"
                                   class="form-control <#if errors?? && errors['title']??>is-invalid</#if>"
                                   value="${(project.title)!''}" placeholder="Наприклад: Розробка CRM системи">
                            <#if errors?? && errors['title']??>
                                <div class="invalid-feedback">${errors['title']}</div>
                            </#if>
                        </div>

                        <div class="mb-4">
                            <label class="form-label">Опис та вимоги</label>
                            <textarea name="description" rows="5"
                                      class="form-control <#if errors?? && errors['description']??>is-invalid</#if>"
                                      placeholder="Опишіть детально, що саме потрібно зробити...">${(project.description)!''}</textarea>
                            <#if errors?? && errors['description']??>
                                <div class="invalid-feedback">${errors['description']}</div>
                            </#if>
                        </div>

                        <div class="alert alert-info border-0 bg-light text-muted small">
                            <i class="bi bi-info-circle me-2"></i> Після створення ваша заявка отримає статус <b>НА РОЗГЛЯДІ</b>. Наш менеджер зв'яжеться з вами найближчим часом.
                        </div>

                        <div class="d-flex justify-content-end gap-2 mt-4">
                            <a href="/customer/projects" class="btn btn-light px-4">Скасувати</a>
                            <button type="submit" class="btn btn-save">Подати заявку</button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
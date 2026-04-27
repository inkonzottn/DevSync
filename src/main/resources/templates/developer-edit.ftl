<!DOCTYPE html>
<html lang="uk">
<head>
    <meta charset="UTF-8">
    <title>Редагувати розробника | DevSync</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">
    <style>
        body { background-color: #f8f9fa; font-family: 'Inter', sans-serif; }
        .card { border: none; border-radius: 15px; box-shadow: 0 4px 20px rgba(0,0,0,0.05); }
        .form-label { font-weight: 600; font-size: 0.9rem; color: #495057; }
        .btn-save { background: #0d6efd; color: white; border-radius: 10px; padding: 10px 25px; }
        .form-control:focus { box-shadow: none; border-color: #0d6efd; }
    </style>
</head>
<body>

<div class="container py-5">
    <div class="row justify-content-center">
        <div class="col-md-8">
            <div class="d-flex align-items-center mb-4">
                <a href="/admin/developers" class="btn btn-light rounded-circle me-3">
                    <i class="bi bi-arrow-left"></i>
                </a>
                <h2 class="fw-bold m-0">Редагування розробника</h2>
            </div>

            <div class="card p-4">
                <form action="/admin/developers/edit/${developer.id}" method="post">
                    <h5 class="mb-4 text-primary">Інформація про акаунт</h5>
                    <div class="row g-3 mb-4">
                        <div class="col-md-6">
                            <label class="form-label">Ім'я</label>
                            <input type="text" name="user.firstName"
                                   class="form-control <#if errors?? && errors['user.firstName']??>is-invalid</#if>"
                                   value="${(developer.user.firstName)!''}" placeholder="Ім'я">
                            <#if errors?? && errors['user.firstName']??>
                                <div class="invalid-feedback">${errors['user.firstName']}</div>
                            </#if>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label">Прізвище</label>
                            <input type="text" name="user.lastName"
                                   class="form-control <#if errors?? && errors['user.lastName']??>is-invalid</#if>"
                                   value="${(developer.user.lastName)!''}" placeholder="Прізвище">
                            <#if errors?? && errors['user.lastName']??>
                                <div class="invalid-feedback">${errors['user.lastName']}</div>
                            </#if>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label">Email</label>
                            <div class="input-group">
                                <input type="text" name="user.email"
                                       class="form-control <#if errors?? && errors['user.email']??>is-invalid</#if>"
                                       value="${(developer.user.email?keep_before("@"))!''}"
                                       placeholder="mike">
                                <span class="input-group-text">@devsync.dev.com</span>
                                <#if errors?? && errors['user.email']??>
                                    <div class="invalid-feedback">${errors['user.email']}</div>
                                </#if>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label">Новий пароль</label>
                            <input type="password" name="user.password"
                                   class="form-control <#if errors?? && errors['user.password']??>is-invalid</#if>"
                                   placeholder="Залиште пустим, щоб не змінювати">
                            <#if errors?? && errors['user.password']??>
                                <div class="invalid-feedback">${errors['user.password']}</div>
                            </#if>
                        </div>
                    </div>

                    <hr class="my-4 opacity-25">

                    <h5 class="mb-4 text-primary">Професійні дані</h5>
                    <div class="row g-3 mb-4">
                        <div class="col-md-4">
                            <label class="form-label">Кваліфікація</label>
                            <select name="qualification" class="form-select">
                                <#list qualifications as q>
                                    <option value="${q}" <#if developer.qualification?? && developer.qualification == q>selected</#if>>${q}</option>
                                </#list>
                            </select>
                        </div>
                        <div class="col-md-4">
                            <label class="form-label">Спеціалізація</label>
                            <select name="specialization" class="form-select">
                                <#list specializations as s>
                                    <option value="${s}" <#if developer.specialization?? && developer.specialization == s>selected</#if>>${s}</option>
                                </#list>
                            </select>
                        </div>
                        <div class="col-md-4">
                            <label class="form-label">Погодинна ставка</label>
                            <input type="number" name="hourlyRate"
                                   class="form-control <#if errors?? && errors['hourlyRate']??>is-invalid</#if>"
                                   value="${(developer.hourlyRate?c)!''}" min="1">
                            <#if errors?? && errors['hourlyRate']??>
                                <div class="invalid-feedback">${errors['hourlyRate']}</div>
                            </#if>
                        </div>
                    </div>

                    <div class="d-flex justify-content-end gap-2 mt-4">
                        <a href="/admin/developers" class="btn btn-light px-4">Скасувати</a>
                        <button type="submit" class="btn btn-save">Зберегти зміни</button>
                    </div>
                </form>
            </div>
        </div>
    </div>
</div>

</body>
</html>
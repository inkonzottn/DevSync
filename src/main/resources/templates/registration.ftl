<#import "client/templ-client.ftl" as p>

<@p.pages>
    <div class="container d-flex justify-content-center align-items-center" style="min-height: 80vh;">
        <div class="card shadow-lg p-4" style="width: 100%; max-width: 500px; border-radius: 15px;">
            <div class="text-center mb-4">
                <h2 class="fw-bold">Реєстрація</h2>
                <p class="text-muted">Створи свій профіль</p>
            </div>

            <#if message??>
                <div class="alert alert-danger text-center">${message}</div>
            </#if>

            <form method="post" action="/registration">
                <div class="row">
                    <div class="col-md-6 mb-3">
                        <label class="form-label">Ім'я</label>
                        <input type="text" name="user.firstName"
                               class="form-control ${(errors.firstName??)?string('is-invalid', '')}"
                               value="${(customer.user.firstName)!''}" placeholder="Майк">
                        <#if errors.firstName??>
                            <div class="invalid-feedback">${errors.firstName}</div>
                        </#if>
                    </div>

                    <div class="col-md-6 mb-3">
                        <label class="form-label">Прізвище</label>
                        <input type="text" name="user.lastName"
                               class="form-control ${(errors.lastName??)?string('is-invalid', '')}"
                               value="${(customer.user.lastName)!''}" placeholder="Вазовський">
                        <#if errors.lastName??>
                            <div class="invalid-feedback">${errors.lastName}</div>
                        </#if>
                    </div>
                </div>

                <div class="mb-3">
                    <label class="form-label">Назва компанії</label>
                    <input type="text" name="companyName"
                           class="form-control ${(errors.companyName??)?string('is-invalid', '')}"
                           value="${(customer.companyName)!''}" placeholder="Корп. Монстрів">
                    <#if errors.companyName??>
                        <div class="invalid-feedback">${errors.companyName}</div>
                    </#if>
                </div>

                <div class="mb-3">
                    <label class="form-label">Пошта</label>
                    <input type="text" name="user.email"
                           class="form-control ${(errors.email??)?string('is-invalid', '')}"
                           value="${(customer.user.email)!''}" placeholder="mike@dev.com">
                    <#if errors.email??>
                        <div class="invalid-feedback">${errors.email}</div>
                    </#if>
                </div>

                <div class="mb-3">
                    <label class="form-label">Пароль</label>
                    <input type="password" name="user.password"
                           class="form-control ${(errors.password??)?string('is-invalid', '')}"
                           placeholder="••••••••">
                    <#if errors.password??>
                        <div class="invalid-feedback">${errors.password}</div>
                    </#if>
                </div>

                <button type="submit" class="btn btn-success w-100 py-2 shadow-sm">
                    Створити обліковий запис
                </button>

                <div class="text-center mt-3">
                    <span class="text-muted small">Вже маєте обліковий запис?</span><br>
                    <a href="/login" class="text-decoration-none fw-bold">Увійти</a>
                </div>
            </form>
        </div>
    </div>
</@p.pages><#import "client/templ-client.ftl" as p>
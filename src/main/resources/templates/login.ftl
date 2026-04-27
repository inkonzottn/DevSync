<#import "client/templ-client.ftl" as p>

<@p.pages>
    <div class="container d-flex justify-content-center align-items-center" style="min-height: 80vh;">
        <div class="card shadow-lg p-4" style="width: 100%; max-width: 400px; border-radius: 15px;">
            <div class="text-center mb-4">
                <h2 class="fw-bold">Вхід</h2>
                <p class="text-muted">DevSync: Команда розробників</p>
            </div>

            <form method="post" action="/login">
                <div class="mb-3">
                    <label for="email" class="form-label">Пошта</label>
                    <input type="email" name="email" id="email"
                           class="form-control" placeholder="example@dev.com" required>
                </div>

                <div class="mb-3">
                    <label for="password" class="form-label">Пароль</label>
                    <input type="password" name="password" id="password"
                           class="form-control" placeholder="••••••••" required>
                </div>

                <#if RequestParameters.error??>
                    <div class="alert alert-danger p-2 text-center" style="font-size: 0.9rem;">
                        Неправильна пошта або пароль
                    </div>
                </#if>

                <button type="submit" class="btn btn-primary w-100 py-2 shadow-sm">
                    Увійти
                </button>

                <div class="text-center mt-3">
                    <span class="text-muted small">Ще не маєте облікового запису?</span><br>
                    <a href="/registration" class="text-decoration-none fw-bold">Зареєструватись</a>
                </div>
            </form>
        </div>
    </div>
</@p.pages>
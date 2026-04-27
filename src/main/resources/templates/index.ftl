<#import "client/templ-client.ftl" as p>

<@p.pages>
    <div class="hero-section">
        <div class="container gradient-bg text-center mt-5 pt-5 pb-5">
            <div class="badge-pill mb-4 mx-auto">
                <i class="bi bi-stars"></i> Команда розробників, яка синхронізує ідеї
            </div>
            <h1 class="display-2 fw-bold main-title mb-4">Будуємо продукти</h1>
            <p class="lead text-muted mb-5 mx-auto hero-desc">
                DevSync — це команда, що перетворює ваші ідеї на реальні цифрові продукти.
                Дизайн, розробка та підтримка — все в одному місці.
            </p>

            <div class="d-flex justify-content-center gap-3">
                <#if !isAuth>
                    <a href="/registration" class="btn btn-primary btn-lg px-5 py-3 rounded-pill shadow">Зареєструватись <i class="bi bi-arrow-right ms-2"></i></a>
                    <a href="/login" class="btn btn-light btn-lg px-5 py-3 rounded-pill border">Увійти</a>
<#--                <#else>-->
<#--                    <a href="/customer" class="btn btn-primary btn-lg px-5 py-3 rounded-pill shadow">Перейти до проектів</a>-->
                </#if>
            </div>
        </div>

        <div class="container mt-5 pt-5 pb-5">
            <h2 class="text-center fw-bold mb-5">Чому обирають нас</h2>
            <p class="text-center text-muted mb-5">Ми поєднуємо технічну експертизу з увагою до деталей</p>

            <div class="row g-4">
                <div class="col-md-6 col-lg-3">
                    <div class="feature-card h-100 p-4 shadow-sm border-0">
                        <div class="icon-wrapper mb-4 bg-primary-light">
                            <i class="bi bi-people text-primary"></i>
                        </div>
                        <h5 class="fw-bold">Злагоджена команда</h5>
                        <p class="text-muted small">Досвідчені розробники, дизайнери та менеджери працюють як єдиний механізм.</p>
                    </div>
                </div>
                <div class="col-md-6 col-lg-3">
                    <div class="feature-card h-100 p-4 shadow-sm border-0">
                        <div class="icon-wrapper mb-4 bg-blue-light">
                            <i class="bi bi-lightning-charge text-info"></i>
                        </div>
                        <h5 class="fw-bold">Швидка розробка</h5>
                        <p class="text-muted small">Від ідеї до MVP за тижні, а не місяці. Agile-підхід у кожному проекті.</p>
                    </div>
                </div>
                <div class="col-md-6 col-lg-3">
                    <div class="feature-card h-100 p-4 shadow-sm border-0">
                        <div class="icon-wrapper mb-4 bg-navy-light">
                            <i class="bi bi-shield-check text-navy"></i>
                        </div>
                        <h5 class="fw-bold">Надійний код</h5>
                        <p class="text-muted small">Чистий, тестований код з документацією та підтримкою після запуску.</p>
                    </div>
                </div>
                <div class="col-md-6 col-lg-3">
                    <div class="feature-card h-100 p-4 shadow-sm border-0">
                        <div class="icon-wrapper mb-4 bg-cyan-light">
                            <i class="bi bi-palette text-cyan"></i>
                        </div>
                        <h5 class="fw-bold">Сучасний дизайн</h5>
                        <p class="text-muted small">UI/UX, що вражає. Кожен піксель має значення для нас.</p>
                    </div>
                </div>
            </div>
        </div>
    </div>
</@p.pages>
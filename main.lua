<!DOCTYPE html>
<html lang="ru">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>MM2 Script UI - Левая панель</title>
    <style>
        /* Глобальный фон и шрифты */
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            background: #0b0b1a;
            font-family: 'Segoe UI', 'Gotham', system-ui, sans-serif;
            display: flex;
            justify-content: center;
            align-items: center;
            min-height: 100vh;
            padding: 20px;
        }

        /* Основной контейнер UI */
        .ui-container {
            display: flex;
            gap: 0;
            background: rgba(10, 10, 30, 0.85);
            backdrop-filter: blur(20px);
            -webkit-backdrop-filter: blur(20px);
            border-radius: 20px;
            border: 1px solid rgba(255, 255, 255, 0.06);
            box-shadow: 0 25px 80px rgba(0, 0, 0, 0.8), 0 0 60px rgba(80, 0, 255, 0.1);
            overflow: hidden;
            max-width: 1100px;
            width: 100%;
            height: 700px;
            color: #e0d8f0;
        }

        /* ===== ЛЕВАЯ ПАНЕЛЬ ===== */
        .left-panel {
            width: 380px;
            min-width: 320px;
            background: rgba(16, 12, 35, 0.7);
            border-right: 1px solid rgba(255, 255, 255, 0.05);
            display: flex;
            flex-direction: column;
            padding: 18px 16px 14px;
            height: 100%;
            overflow: hidden;
        }

        /* Верхний колонтитул */
        .panel-header {
            display: flex;
            align-items: center;
            justify-content: space-between;
            padding-bottom: 14px;
            border-bottom: 1px solid rgba(255, 255, 255, 0.04);
        }
        .logo {
            display: flex;
            align-items: center;
            gap: 10px;
            font-size: 20px;
            font-weight: 800;
            background: linear-gradient(135deg, #b380ff, #60d0ff);
            -webkit-background-clip: text;
            background-clip: text;
            color: transparent;
        }
        .logo small {
            font-size: 12px;
            font-weight: 400;
            color: #7a6a9a;
            background: rgba(255,255,255,0.04);
            padding: 2px 12px;
            border-radius: 30px;
            letter-spacing: 0.3px;
        }
        .status-badge {
            font-size: 11px;
            background: #00b86b33;
            border: 1px solid #00b86b66;
            padding: 4px 14px;
            border-radius: 30px;
            color: #80e0b0;
            font-weight: 600;
            letter-spacing: 0.3px;
        }

        /* Список навигационных кнопок */
        .nav-list {
            display: flex;
            flex-direction: column;
            gap: 6px;
            padding: 16px 0 12px;
            flex-shrink: 0;
        }

        .nav-btn {
            display: flex;
            align-items: center;
            gap: 14px;
            padding: 12px 16px;
            border-radius: 14px;
            background: transparent;
            border: none;
            color: #a090b8;
            font-size: 15px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.2s ease;
            text-align: left;
            width: 100%;
            font-family: inherit;
            position: relative;
        }
        .nav-btn .badge {
            margin-left: auto;
            background: rgba(255,255,255,0.06);
            padding: 1px 12px;
            border-radius: 30px;
            font-size: 12px;
            color: #7a6a9a;
            font-weight: 500;
        }
        .nav-btn:hover {
            background: rgba(255, 255, 255, 0.04);
            color: #d0c0e8;
        }
        .nav-btn.active {
            background: rgba(128, 0, 255, 0.2);
            color: #fff;
            box-shadow: inset 3px 0 0 #8b4dff, 0 4px 20px rgba(128, 0, 255, 0.1);
        }
        .nav-btn .icon {
            font-size: 20px;
            width: 28px;
            text-align: center;
        }

        /* Содержимое левой панели (динамическое) */
        .panel-content {
            flex: 1;
            overflow-y: auto;
            padding: 6px 4px 10px;
            margin-top: 4px;
            border-top: 1px solid rgba(255, 255, 255, 0.03);
            scrollbar-width: thin;
            scrollbar-color: #3a2a5a transparent;
        }
        .panel-content::-webkit-scrollbar { width: 4px; }
        .panel-content::-webkit-scrollbar-track { background: transparent; }
        .panel-content::-webkit-scrollbar-thumb { background: #3a2a5a; border-radius: 10px; }

        /* Стили для контента вкладок */
        .tab-content {
            display: none;
            animation: fadeSlide 0.25s ease;
        }
        .tab-content.active {
            display: block;
        }

        @keyframes fadeSlide {
            from { opacity: 0.3; transform: translateX(8px); }
            to { opacity: 1; transform: translateX(0); }
        }

        .tab-content h2 {
            font-size: 18px;
            font-weight: 700;
            color: #c8b8e8;
            margin-bottom: 10px;
            letter-spacing: 0.3px;
        }
        .tab-content .subhead {
            font-size: 13px;
            color: #8a7aa8;
            margin-bottom: 16px;
            background: rgba(255,255,255,0.03);
            padding: 8px 14px;
            border-radius: 12px;
            border-left: 3px solid #6a4a9a;
        }
        .tab-content .stat-row {
            display: flex;
            justify-content: space-between;
            padding: 8px 0;
            border-bottom: 1px solid rgba(255,255,255,0.04);
            font-size: 14px;
        }
        .tab-content .stat-row .label { color: #9a8ab0; }
        .tab-content .stat-row .value { font-weight: 600; color: #e0d8f0; }
        .tab-content .stat-row .value.highlight-red { color: #ff5a6a; }
        .tab-content .stat-row .value.highlight-blue { color: #5aa0ff; }
        .tab-content .stat-row .value.highlight-green { color: #50d090; }
        .tab-content .stat-row .value.highlight-gold { color: #ffc850; }

        .tag {
            display: inline-block;
            padding: 2px 14px;
            border-radius: 30px;
            font-size: 12px;
            font-weight: 600;
        }
        .tag.green { background: #00b86b33; color: #80e0b0; }
        .tag.red { background: #ff3b3b33; color: #ff7a7a; }
        .tag.orange { background: #ff8c1a33; color: #ffb347; }
        .tag.blue { background: #3b7bff33; color: #80b0ff; }

        .mini-toggle {
            display: inline-block;
            background: rgba(255,255,255,0.06);
            padding: 4px 14px;
            border-radius: 30px;
            font-size: 13px;
            font-weight: 600;
            margin: 3px 4px 3px 0;
        }
        .mini-toggle.on { background: #00b86b44; color: #80e0b0; border: 1px solid #00b86b55; }
        .mini-toggle.off { background: #3a2a5a55; color: #8a7aa8; border: 1px solid #4a3a6a55; }

        .warning-box {
            background: rgba(255, 60, 60, 0.08);
            border-left: 4px solid #ff5a5a;
            padding: 10px 14px;
            border-radius: 10px;
            margin-top: 12px;
            font-size: 13px;
            color: #d0b0b0;
        }

        .file-item {
            padding: 6px 12px;
            background: rgba(255,255,255,0.03);
            border-radius: 10px;
            margin: 4px 0;
            font-size: 14px;
            border-left: 3px solid #6a4a9a;
        }

        /* Нижний блок (футер) */
        .panel-footer {
            border-top: 1px solid rgba(255, 255, 255, 0.05);
            padding-top: 12px;
            margin-top: 6px;
            flex-shrink: 0;
            font-size: 12px;
        }
        .footer-stats {
            display: flex;
            justify-content: space-between;
            flex-wrap: wrap;
            gap: 6px 10px;
            color: #7a6a9a;
        }
        .footer-stats span strong { color: #b0a0c8; font-weight: 500; }
        .panic-btn {
            margin-top: 10px;
            width: 100%;
            padding: 10px;
            background: #c0392b;
            border: none;
            border-radius: 12px;
            color: #fff;
            font-weight: 700;
            font-size: 14px;
            letter-spacing: 0.5px;
            cursor: pointer;
            transition: 0.15s;
            text-transform: uppercase;
        }
        .panic-btn:hover {
            background: #e74c3c;
            transform: scale(1.01);
            box-shadow: 0 0 30px #e74c3c55;
        }

        /* ===== ПРАВАЯ ПАНЕЛЬ (заглушка) ===== */
        .right-panel {
            flex: 1;
            background: rgba(8, 8, 22, 0.6);
            display: flex;
            align-items: center;
            justify-content: center;
            color: #4a3a6a;
            font-size: 22px;
            font-weight: 300;
            letter-spacing: 1px;
            padding: 30px;
            text-align: center;
            border-left: 1px solid rgba(255,255,255,0.03);
        }
        .right-panel span {
            background: rgba(255,255,255,0.02);
            padding: 20px 40px;
            border-radius: 20px;
            border: 1px dashed #3a2a5a;
        }

        /* Адаптивность */
        @media (max-width: 820px) {
            .ui-container { flex-direction: column; height: auto; max-height: 95vh; }
            .left-panel { width: 100%; min-width: unset; border-right: none; border-bottom: 1px solid rgba(255,255,255,0.05); height: 60vh; }
            .right-panel { min-height: 120px; }
        }
    </style>
</head>
<body>

<div class="ui-container">
    <!-- ЛЕВАЯ ПАНЕЛЬ -->
    <div class="left-panel" id="leftPanel">
        <!-- Верхний колонтитул -->
        <div class="panel-header">
            <div class="logo">
                🔫 MM2 CHEAT <small>v4.2</small>
            </div>
            <div class="status-badge">● ONLINE</div>
        </div>

        <!-- Навигация -->
        <div class="nav-list">
            <button class="nav-btn active" data-tab="tab1"><span class="icon">👁️</span> ESP & VISUALS <span class="badge">3</span></button>
            <button class="nav-btn" data-tab="tab2"><span class="icon">🎯</span> COMBAT & AIMBOT <span class="badge">2</span></button>
            <button class="nav-btn" data-tab="tab3"><span class="icon">✈️</span> MOVEMENT & FLY <span class="badge">4</span></button>
            <button class="nav-btn" data-tab="tab4"><span class="icon">💰</span> AUTOFARM COINS <span class="badge">1</span></button>
            <button class="nav-btn" data-tab="tab5"><span class="icon">⚙️</span> CONFIGS & PRESETS <span class="badge">0</span></button>
            <button class="nav-btn" data-tab="tab6"><span class="icon">🌀</span> MISC & UTILITIES <span class="badge">5</span></button>
        </div>

        <!-- Динамическое содержимое -->
        <div class="panel-content" id="panelContent">

            <!-- ===== TAB 1: ESP ===== -->
            <div class="tab-content active" id="tab1">
                <h2>ESP & WORLD VISUALIZATION</h2>
                <div class="subhead">Отображение сквозь стены: <span style="color:#80e0b0;font-weight:700;">АКТИВНО</span> (Отрендерено: 14 объектов)</div>

                <div class="stat-row"><span class="label">⚔️ Murderer</span><span class="value highlight-red">DarkKnight_99</span></div>
                <div class="stat-row"><span class="label">🤠 Sheriff</span><span class="value highlight-blue">SniperWolf_42</span></div>
                <div class="stat-row"><span class="label">🔫 Dropped Gun</span><span class="value highlight-gold">Координаты: [23, 5, -12]</span></div>
                <div class="stat-row"><span class="label">🧑 Innocents</span><span class="value">8 живых</span></div>

                <div style="margin-top:12px;padding:8px 12px;background:#00b86b15;border-radius:12px;border-left:3px solid #00b86b;">
                    <span style="font-size:13px;color:#80e0b0;">✅ Bypass Anti-Cheat Visuals: <strong>SECURE</strong></span>
                </div>

                <div style="margin-top:16px;">
                    <span class="mini-toggle on">Players ESP</span>
                    <span class="mini-toggle on">Items ESP</span>
                    <span class="mini-toggle off">Radar 2D</span>
                </div>
            </div>

            <!-- ===== TAB 2: COMBAT ===== -->
            <div class="tab-content" id="tab2">
                <h2>COMBAT & TARGETING SYSTEM</h2>
                <div class="subhead">Текущая цель: <span style="color:#ff5a6a;font-weight:700;">TARGET: DarkKnight_99 [Murderer]</span></div>

                <div class="stat-row"><span class="label">🎯 FOV Radius</span><span class="value">150 px</span></div>
                <div class="stat-row"><span class="label">📈 Prediction Mode</span><span class="value highlight-green">ENABLED</span></div>
                <div class="stat-row"><span class="label">🤫 Silent Aim Status</span><span class="value highlight-green">Safe</span></div>
                <div class="stat-row"><span class="label">🔪 Kill Aura Range</span><span class="value">3.5 studs</span></div>

                <div style="margin-top:12px;display:flex;gap:8px;flex-wrap:wrap;">
                    <span class="mini-toggle on">AIM: ON</span>
                    <span class="mini-toggle off">SILENT: OFF</span>
                    <span class="mini-toggle on">TRIGGER: ON</span>
                </div>
            </div>

            <!-- ===== TAB 3: MOVEMENT ===== -->
            <div class="tab-content" id="tab3">
                <h2>MOVEMENT & PHYSICS MODIFICATIONS</h2>
                <div class="subhead">Noclip: <span style="color:#ff7a7a;">OFF</span> | Fly: <span style="color:#80e0b0;">ON</span></div>

                <div class="stat-row"><span class="label">🚀 Current Speed</span><span class="value">16 → <span style="color:#ffc850;">50</span></span></div>
                <div class="stat-row"><span class="label">🌀 Flin / Dodge State</span><span class="value highlight-green">READY</span></div>
                <div style="font-size:13px;color:#9a8ab0;padding:4px 0 8px;">Автоматически уводит хитбокс при приближении ножа &lt; 5 studs</div>

                <div class="warning-box">
                    ⚠️ Velocity Check: <strong style="color:#ffaa00;">RISK LEVEL - LOW</strong><br>
                    <span style="font-size:12px;">Не выставляйте скорость выше 60 во избежание кика.</span>
                </div>
            </div>

            <!-- ===== TAB 4: AUTOFARM ===== -->
            <div class="tab-content" id="tab4">
                <h2>XP & COIN AUTOFARM MANAGER</h2>
                <div class="subhead">STATUS: <span style="color:#80e0b0;font-weight:700;">FARMING...</span></div>

                <div class="stat-row"><span class="label">🪙 Coins Collected</span><span class="value highlight-gold">1 450</span></div>
                <div class="stat-row"><span class="label">⏱️ Coins Per Minute</span><span class="value highlight-green">45/min</span></div>
                <div class="stat-row"><span class="label">🎒 Bags Filled</span><span class="value">12 / ∞</span></div>
                <div class="stat-row"><span class="label">📈 Level Up Estimation</span><span class="value">14 mins</span></div>

                <div style="margin-top:10px;background:#1a1a2e;border-radius:12px;padding:8px 12px;font-size:12px;color:#7a6a9a;font-family:monospace;">
                    [15:32:01] Teleported to Coin (Safe Zone)<br>
                    [15:32:04] Tween Speed Adjusted (Anti-Rubberband)<br>
                    [15:32:10] Player spectating detected! Paused 3s.
                </div>
            </div>

            <!-- ===== TAB 5: CONFIGS ===== -->
            <div class="tab-content" id="tab5">
                <h2>CONFIGURATION & PRESET MANAGER</h2>
                <div class="subhead">ACTIVE CONFIG: <span style="color:#80e0b0;">Legit_Sheriff_V2.json</span></div>

                <div class="stat-row"><span class="label">📁 Workspace Path</span><span class="value" style="font-size:12px;">/MM2_Cheats/Configs/</span></div>

                <div class="file-item">📁 Rage_Murderer.json <span style="float:right;font-size:12px;color:#7a6a9a;">агрессивный</span></div>
                <div class="file-item">📁 Legit_Casual.json <span style="float:right;font-size:12px;color:#7a6a9a;">безопасный</span></div>
                <div class="file-item">📁 AFK_CoinFarm_Night.json <span style="float:right;font-size:12px;color:#7a6a9a;">ночной фарм</span></div>

                <div style="margin-top:12px;font-size:12px;color:#6a5a8a;background:#0d0d20;padding:8px 12px;border-radius:10px;">
                    ✏️ Вы можете редактировать конфиги через текстовый редактор в папке эксплоита.
                </div>
            </div>

            <!-- ===== TAB 6: MISC ===== -->
            <div class="tab-content" id="tab6">
                <h2>MISCELLANEOUS & SERVER UTILITIES</h2>
                <div class="subhead">Server Info</div>

                <div class="stat-row"><span class="label">🆔 JobId</span><span class="value" style="font-size:11px;">a1b2c3d4-... (Rejoin)</span></div>
                <div class="stat-row"><span class="label">⏳ Server Age</span><span class="value">2h 14min</span></div>
                <div class="stat-row"><span class="label">👥 Player Count</span><span class="value">11 / 12</span></div>

                <div style="margin-top:10px;">
                    <span class="mini-toggle off">Auto-Open Boxes</span>
                    <span class="mini-toggle on">Auto-Equip Elite</span>
                </div>
                <div style="margin-top:8px;">
                    <span class="mini-toggle on">Chat Spy: ACTIVE</span>
                    <span class="mini-toggle on">Anti-Afk: PROTECTED</span>
                </div>
            </div>
        </div>

        <!-- Нижний блок (футер) -->
        <div class="panel-footer">
            <div class="footer-stats">
                <span>👤 <strong>Player123</strong></span>
                <span>📦 Build: <strong>v4.2.1-Stable</strong></span>
                <span>🟢 FPS: <strong>58.4</strong></span>
                <span>📶 Ping: <strong>23ms</strong></span>
                <span>🧠 Mem: <strong>1102 MB</strong></span>
            </div>
            <button class="panic-btn" id="panicBtn">🔴 PANIC BUTTON (UNLOAD CHEAT)</button>
        </div>
    </div>

    <!-- ПРАВАЯ ПАНЕЛЬ (заглушка) -->
    <div class="right-panel">
        <span>⚙️ Правая панель<br><small style="font-size:16px;">(настройки выбранной вкладки)</small></span>
    </div>
</div>

<script>
    // Переключение вкладок
    const navBtns = document.querySelectorAll('.nav-btn');
    const tabContents = {
        tab1: document.getElementById('tab1'),
        tab2: document.getElementById('tab2'),
        tab3: document.getElementById('tab3'),
        tab4: document.getElementById('tab4'),
        tab5: document.getElementById('tab5'),
        tab6: document.getElementById('tab6'),
    };

    navBtns.forEach(btn => {
        btn.addEventListener('click', function() {
            // Убрать активный класс у всех кнопок
            navBtns.forEach(b => b.classList.remove('active'));
            this.classList.add('active');

            // Скрыть все вкладки
            Object.values(tabContents).forEach(tab => tab.classList.remove('active'));

            // Показать нужную вкладку
            const target = this.dataset.tab;
            if (tabContents[target]) {
                tabContents[target].classList.add('active');
            }
        });
    });

    // Кнопка PANIC
    document.getElementById('panicBtn').addEventListener('click', function() {
        if (confirm('⚠️ Действительно выгрузить чит? Интерфейс будет стёрт.')) {
            // В реальном скрипте здесь был бы код очистки.
            // Для макета просто покажем сообщение.
            const panel = document.getElementById('leftPanel');
            panel.style.transition = 'all 0.3s ease';
            panel.style.opacity = '0.3';
            panel.style.filter = 'blur(4px)';
            setTimeout(() => {
                alert('🧹 Чит выгружен. Интерфейс очищен.');
                panel.style.opacity = '1';
                panel.style.filter = 'blur(0)';
            }, 400);
        }
    });
</script>

</body>
</html>

# ============================
# Etapa 1 — Imagem base oficial
# ============================
FROM quay.io/keycloak/keycloak:26.4.2

# ============================
# Etapa 2 — Configurações padrão
# ============================
# As variáveis sensíveis (usuário, senha, host, etc.) serão injetadas
# pelo Dokploy no ambiente, então não definimos valores fixos aqui.
ENV KC_DB=postgres \
    KC_DB_SCHEMA=keycloak \
    KC_TRANSACTION_XA_ENABLED=false \
    KC_HTTP_ENABLED=true \
    KC_HEALTH_ENABLED=true \
    KC_METRICS_ENABLED=true \
    KC_PROXY=edge

# ============================
# Etapa 3 — Expor porta padrão
# ============================
EXPOSE 8080

# ============================
# Etapa 4 — Volume persistente
# ============================
# Esse volume garante que dados e temas persistam entre containers.
VOLUME ["/opt/keycloak/data"]

# ============================
# Etapa 5 — Comando de inicialização
# ============================
ENTRYPOINT ["/opt/keycloak/bin/kc.sh", "start", "--optimized"]

# ============================
# Etapa 1 — Imagem base oficial
# ============================
FROM quay.io/keycloak/keycloak:26.4.2 as builder

# Copia o código base (se quiser incluir providers, temas, etc.)
# COPY ./providers /opt/keycloak/providers
# COPY ./themes /opt/keycloak/themes

# Executa o build do Keycloak (gera a versão otimizada)
RUN /opt/keycloak/bin/kc.sh build

# ============================
# Etapa 2 — Imagem final (runtime)
# ============================
FROM quay.io/keycloak/keycloak:26.4.2

# Copia o servidor já otimizado da etapa anterior
COPY --from=builder /opt/keycloak/ /opt/keycloak/

# Variáveis de ambiente padrão (outras serão injetadas pelo Dokploy)
ENV KC_DB=postgres \
    KC_DB_SCHEMA=keycloak \
    KC_TRANSACTION_XA_ENABLED=false \
    KC_HTTP_ENABLED=true \
    KC_HEALTH_ENABLED=true \
    KC_METRICS_ENABLED=true \
    KC_PROXY=edge

# Expor porta padrão
EXPOSE 8080

# Volume persistente para dados (ex: usuários, sessões, temas)
VOLUME ["/opt/keycloak/data"]

# Iniciar em modo otimizado (já buildado)
ENTRYPOINT ["/opt/keycloak/bin/kc.sh", "start"]

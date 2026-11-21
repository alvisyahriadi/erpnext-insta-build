
FROM frappe/erpnext:v16.60.0

USER frappe

ENV NVM_DIR=/home/frappe/.nvm
ENV PATH=/home/frappe/.nvm/versions/node/v24.22.3/bin:$PATH

WORKDIR /home/frappe/frappe-bench

RUN set -eux; \
    bench get-app --branch version-16 https://github.com/frappe/hrms.git; \
    bench get-app --branch 15.36.0 https://github.com/defendicon/POS-Awesome-V15.git; \
    bench get-app --branch v1.4.1 https://github.com/agile-technica/erpnext-indonesia-localization.git; \
    cd apps/posawesome; \
    yarn --cwd frontend install --cache-folder /tmp/yarn-cache; \
    yarn --cwd frontend build; \
    cd /home/frappe/frappe-bench; \
    bench build --production \
        --app hrms \
        --app posawesome \
        --app erpnext_indonesia_localization; \
    find apps/hrms apps/posawesome apps/erpnext_indonesia_localization \
        -type d -name node_modules -prune -exec rm -rf '{}' +; \
    rm -rf /tmp/yarn-cache /home/frappe/.cache

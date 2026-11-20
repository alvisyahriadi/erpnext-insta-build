
FROM frappe/erpnext:v16.60.0

USER frappe

ENV NVM_DIR=/home/frappe/.nvm
ENV PATH=/home/frappe/.nvm/versions/node/v24.22.3/bin:$PATH

WORKDIR /home/frappe/frappe-bench

# Install HRMS
RUN bench get-app --branch version-16 https://github.com/frappe/hrms.git

# Install POS Awesome
RUN bench get-app --branch 15.36.0 https://github.com/defendicon/POS-Awesome-V15.git

# Install Indonesia Localization (Coretax)
RUN bench get-app --branch v1.4.1 https://github.com/agile-technica/erpnext-indonesia-localization.git

# Build POS Awesome frontend
RUN cd apps/posawesome \
    && yarn --cwd frontend install --cache-folder /tmp/yarn-cache \
    && yarn --cwd frontend build \
    && rm -rf frontend/node_modules /tmp/yarn-cache

# Build application assets
RUN bench build --production \
    --app hrms \
    --app posawesome \
    --app erpnext_indonesia_localization

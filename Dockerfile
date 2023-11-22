# ---- Base Node ----
FROM harbor.builder.gamewarden.io/baseimages/nodejs-cgr-dev:18.16.0 AS build
WORKDIR /app
COPY . .
RUN npm run build

# ---- Production ----
FROM harbor.builder.gamewarden.io/baseimages/nodejs-cgr-dev:18.16.0 AS production
WORKDIR /app
COPY --chown=node:node --from=build /app/node_modules ./node_modules
COPY --chown=node:node --from=build /app/.next ./.next
COPY --chown=node:node --from=build /app/public ./public
COPY --chown=node:node --from=build /app/package*.json ./
COPY --chown=node:node --from=build /app/next.config.js ./next.config.js
COPY --chown=node:node --from=build /app/next-i18next.config.js ./next-i18next.config.js

# Expose the port the app will run on
EXPOSE 3000

# Start the application
CMD ["npm", "start"]
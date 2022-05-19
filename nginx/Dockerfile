FROM nginx:latest
COPY ./web.conf /etc/nginx/conf.d/
RUN rm -f /etc/nginx/conf.d/default.conf
CMD ["nginx", "-g", "daemon off;"]

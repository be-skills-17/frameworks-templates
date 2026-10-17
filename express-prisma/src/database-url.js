// The competition environment passes DB_HOST, DB_PORT, DB_DATABASE, DB_USERNAME and DB_PASSWORD to the container:
// build Prisma's DATABASE_URL from them (it wins over .env). Imported first by server.js, before Prisma loads.
const { DB_HOST, DB_PORT = '3306', DB_DATABASE, DB_USERNAME, DB_PASSWORD = '' } = process.env;

if (DB_HOST && DB_DATABASE && DB_USERNAME) {
    const credentials = `${encodeURIComponent(DB_USERNAME)}:${encodeURIComponent(DB_PASSWORD)}`;
    process.env.DATABASE_URL = `mysql://${credentials}@${DB_HOST}:${DB_PORT}/${encodeURIComponent(DB_DATABASE)}`;
}

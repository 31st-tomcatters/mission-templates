const templatelib = require('@jtff/miztemplate-lib');

const config = require("../../config.json");
const jtffci = new templatelib.MizTemplateCI(config);

if (process.argv.slice(2).length > 0) {
    templatelib.setVersion(jtffci, process.argv.slice(2)[0], "./config.json");
} else {
    templatelib.getVersion(jtffci);
}

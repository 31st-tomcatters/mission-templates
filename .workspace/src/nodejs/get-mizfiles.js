const templatelib = require('@jtff/miztemplate-lib');

const config = require("../../../config.json");
const jtffci = new templatelib.MizTemplateCI(config);

templatelib.getmizfiles(jtffci);

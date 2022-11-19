const templatelib = require('@jtff/miztemplate-lib');
const config = require("../../config.json");
const jtffci = new templatelib.MizTemplateCI(config);

templatelib.injectScripts(jtffci, process.env.npm_config_mission);

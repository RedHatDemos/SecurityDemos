var fs = require('fs');

function initialize(workshop) {
    workshop.load_workshop();

    try {
        files = fs.readdirSync('/var/run/workshop-vars')
        for (var i=0; i < files.length; i++) {
            console.log(files[i])
            if (files[i].match(/^[a-zA-Z_][a-zA-Z0-9_]+$/)) {
                console.log(files[i])
                workshop.data_variable(files[i], fs.readFileSync('/var/run/workshop-vars/' + files[i], 'utf8'));
            }
        }
    } catch(err) {
        console.log(err)
    }

    try {
        workshop_vars = JSON.parse(process.env['WORKSHOP_VARS'])
        for (var varname in workshop_vars) {
            workshop.data_variable(varname, workshop_vars[varname]);
        }
    } catch(err) {}
}

exports.default = initialize;

module.exports = exports.default;

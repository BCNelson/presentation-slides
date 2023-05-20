/**
 * @typedef {Parameters<import('enquirer').prompt>} PromptOptions
 */

/**
 * 
 * @param {object} context 
 * @param {import('enquirer')} context.inquirer
 * @param {Record<string, string>} context.args
 * @returns 
 */
function promptForTemplate({ inquirer, args }) {

    const questions = [];

    if (!args.name) {
        questions.push({
            type: 'input',
            name: 'name',
            message: 'What is the name of the presentation?'
        })
    }

    //title
    if (!args.title) {
        questions.push({
            type: 'input',
            name: 'title',
            message: 'What is the title of the presentation?'
        })
    }

    return inquirer.prompt(questions)

}

module.exports = {
    prompt: promptForTemplate
}
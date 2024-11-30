const prompts = require('prompts');

const questions = [
  {
    type: 'text',
    name: 'username',
    message: 'Please enter your Git username'
  },
  {
    type: 'text',
    name: 'email',
    message: 'Please enter your Git email address'
  }
];

(async () => {
  const response = await prompts(questions);
 
  return JSON.stringify(response);
})();

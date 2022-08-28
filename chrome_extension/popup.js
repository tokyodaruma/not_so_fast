const button = document.querySelector('#clickMe');

// add click event listener
button.addEventListener('click', (event) => {
    event.preventDefault();

    const token = document.querySelector('#token').value;
    const email = document.querySelector('#email').value;

    if (token && email) {
      // send message to background script with token
      chrome.storage.sync.set({key: [token, email]}, () => {
        console.log('Values are set');
        window.location.replace('./popup-token-submitted.html');
      });
    } else {
        document.querySelector('#token').placeholder = "Enter your token.";
        document.querySelector('#email').placeholder = "Enter your email.";
        document.querySelector('#token').style.border = 'thin solid red';
        document.querySelector('#email').style.border = 'thin solid red';
        document.querySelector('#token').classList.add('white_placeholder');
        document.querySelector('#email').classList.add('white_placeholder');
    }
});

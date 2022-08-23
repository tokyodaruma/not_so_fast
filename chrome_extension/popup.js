const button = document.querySelector('#clickMe');

// add click event listener
button.addEventListener('click', () => {

    // open a new tab
    const tab = window.open('https://not-so-fast.herokuapp.com/users/sign_in', '_blank');

});

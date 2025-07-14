function purchaseMembership(containerId, cost) {
    var userPointsElement = document.getElementById('points');
    var userPoints = parseInt(userPointsElement.innerText);
    var button = document.getElementById('button' + containerId);
    var errorMessageContainer = document.querySelector('#container' + containerId + ' .errorMessage');
    
    if (userPoints >= cost) {
      // Deduct points and update display
      userPoints -= cost;
      userPointsElement.innerText = userPoints;
    
      // Add your logic here to handle the membership purchase for the selected container
      alert('Membership purchased for Container ' + containerId);
    } else {
      // Display error message in the container's errorMessage div
      errorMessageContainer.innerText = '*Insufficient points for this membership.';
      errorMessageContainer.style.display = 'block';

      // Alternatively, you can use a common errorMessageDiv for all containers
      // errorMessageDiv.innerText = 'Not enough points to purchase this membership.';
      // errorMessageDiv.style.display = 'block';

      // Disable the button
      button.classList.remove('enabled');
      button.classList.add('disabled');
      button.disabled = true;
    }
  }
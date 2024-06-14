// Your OpenAI API configuration
const apiBase = "https://api.chatanywhere.com.cn/v1";
const apiKey = "sk-xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx";


// Load existing messages from storage
chrome.storage.sync.get("chatHistory", (data) => {
  if (data.chatHistory) {
    data.chatHistory.forEach((message) => {
      addMessageToChat(message.sender, message.text, false);
    });
  }
});

document.getElementById('send-button').addEventListener('click', async () => {
  const userInput = document.getElementById('user-input').value;
  if (!userInput) return;

  addMessageToChat('User', userInput, true);
  document.getElementById('user-input').value = '';

  try {
    console.log('Sending request to OpenAI API...');
    const response = await fetch(`${apiBase}/chat/completions`, {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
        "Authorization": `Bearer ${apiKey}`
      },
      body: JSON.stringify({
        model: "gpt-3.5-turbo",
        messages: [
          {"role": "system", "content": "You are ChatGPT, a large language model trained by OpenAI."},
          {"role": "user", "content": userInput}
        ]
      })
    });

    if (!response.ok) {
      throw new Error(`API request failed with status ${response.status}`);
    }

    const data = await response.json();
    console.log('Received response from OpenAI API:', data);

    const reply = data.choices[0].message.content.trim();
    addMessageToChat('ChatGPT', reply, true);
  } catch (error) {
    console.error("Error with OpenAI API:", error);
  }
});

function addMessageToChat(sender, message, saveToStorage = true) {
  const messageContainer = document.createElement('div');
  messageContainer.classList.add('message', sender.toLowerCase());

  const senderElement = document.createElement('strong');
  senderElement.textContent = `${sender}: `;
  messageContainer.appendChild(senderElement);

  const messageElement = document.createElement('span');
  messageElement.textContent = message;
  messageContainer.appendChild(messageElement);

  document.getElementById('messages').appendChild(messageContainer);
  messageContainer.scrollIntoView({ behavior: 'smooth' });

  if (saveToStorage) {
    chrome.storage.sync.get("chatHistory", (data) => {
      const chatHistory = data.chatHistory || [];
      chatHistory.push({ sender, text: message });
      chrome.storage.sync.set({ chatHistory });
    });
  }
}
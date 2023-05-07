import axios from 'axios';
import { CloudEvent } from 'cloudevents';

const messageData = 'foo';

const event = new CloudEvent({
  type: 'com.example.someevent',
  source: 'localhost',
  data: Buffer.from(JSON.stringify(messageData)).toString('base64'),
  attributes: {},
});

axios.post('http://localhost:8080', event).then(res => {
  console.log('✅ res:', res.data);
});

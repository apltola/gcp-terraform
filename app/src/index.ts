import { CloudEvent } from 'cloudevents';
import { loadEnv } from './load-env';
import { createPersonEntry } from './contentful';

loadEnv();

function parseMessage(eventData: unknown): unknown {
  const pubsubMessage: any = JSON.parse(JSON.stringify(eventData));
  const message = Buffer.from(pubsubMessage, 'base64').toString();

  try {
    return JSON.parse(message);
  } catch {
    return message;
  }
}

export const main = async (event: CloudEvent) => {
  const message = parseMessage(event.data);
  console.log('😮 received message ->', message);

  try {
    const newContentfulPerson = await createPersonEntry();
    console.log('New Contentful Person created:', newContentfulPerson.sys.id);
  } catch (error) {
    console.error('Error creating Person entry:', (error as Error).message);
  }

  return 'hello from function';
};

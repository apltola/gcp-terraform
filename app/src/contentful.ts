import { createClient, Entry } from 'contentful-management';
import { faker } from '@faker-js/faker';

interface PersonEntryFields {
  name: string;
}

type PersonEntry = Entry & {
  fields: PersonEntryFields;
};

export async function createPersonEntry(): Promise<PersonEntry> {
  const spaceId = process.env.CONTENTFUL_SPACE_ID as string;
  const environmentId = process.env.CONTENTFUL_ENV as string;
  const accessToken = process.env.CONTENTFUL_MANAGEMENT_TOKEN as string;

  const client = createClient({
    accessToken,
  });

  const space = await client.getSpace(spaceId);
  const environment = await space.getEnvironment(environmentId);

  const personName = faker.name.fullName();
  console.log('random person name:', personName);

  const entry = await environment
    .createEntry('person', {
      fields: {
        name: {
          fi: personName,
        },
      },
    })
    .then(entry => entry.publish());

  return entry as PersonEntry;
}

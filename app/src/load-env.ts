import * as yaml from 'js-yaml';
import * as fs from 'fs';
import * as path from 'path';

export function loadEnv(): void {
  console.log('NODE_ENV =>', process.env.NODE_ENV);

  if (process.env.NODE_ENV === 'production') return;

  const envConfig = yaml.load(
    fs.readFileSync(path.resolve(__dirname, '..', '.env.test.yaml'), 'utf8')
  ) as Record<string, string>;

  for (const key in envConfig) {
    process.env[key] = envConfig[key];
  }
}

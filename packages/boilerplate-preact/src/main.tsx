import { FunctionComponent, render } from 'preact';
import { useEffect } from 'preact/hooks';

const Component: FunctionComponent<{ subject: string }> = ({ subject }) => {
  useEffect(() => {
    // eslint-disable-next-line no-console
    console.log(`mounted ${subject}`);

    // eslint-disable-next-line no-console
    return () => console.log(`unmounted ${subject}`);
  }, [subject]);

  // eslint-disable-next-line no-console
  console.log(`rendered ${subject}`);

  return <div>Dies ist ein {subject}!</div>;
};

render(<Component subject="Test" />, document.body);

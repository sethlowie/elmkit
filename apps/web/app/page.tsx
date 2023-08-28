import { bootstrap } from "@elmkit/elm-promise";
import { Button, Header } from "ui";

export default function Page(): JSX.Element {
	bootstrap();
	return (
		<>
			<Header text="Web" />
			<Button />
		</>
	);
}

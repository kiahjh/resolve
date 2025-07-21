import { createSignal, type Component } from "solid-js";
import cx from "clsx";

const WaitlistSignupForm: Component = () => {
  const [isLoading, setIsLoading] = createSignal(false);
  const [isSuccess, setIsSuccess] = createSignal(false);
  const [error, setError] = createSignal<string | null>(null);
  const [email, setEmail] = createSignal(``);

  return (
    <form
      class="flex flex-col items-center"
      onSubmit={async (e) => {
        e.preventDefault();
        setIsLoading(true);
        const res = await fetch(
          process.env.NODE_ENV === `development`
            ? `http://localhost:4000/waitlist-signup`
            : `https://api.resolveapp.net/waitlist-signup`,
          {
            method: `POST`,
            body: JSON.stringify({ email: email() }),
            headers: {
              "Content-Type": `application/json`,
            },
          },
        );
        const json = await res.json();
        setIsLoading(false);
        const success = json.success as boolean;
        if (success) {
          setIsSuccess(true);
        } else {
          setError(json.message || `Unexpected error`);
        }
      }}
    >
      <div
        class={cx(
          `flex flex-col items-center gap-3 transition-[scale,opacity,filter] duration-200`,
          (error() !== null || isSuccess()) && `scale-90 opacity-0 blur-xl`,
        )}
      >
        <span class="text-white text-lg font-medium text-shadow-lg text-shadow-blue-700/10">
          Join the waitlist <i class="fas fa-arrow-down ml-1" />
        </span>
        <div class="flex bg-white/30 rounded-full backdrop-blur-md border-[1.5px] border-white/20 shadow-xl shadow-blue-700/10 ">
          <input
            class="rounded-l-full w-74 sm:w-100 text-2xl pl-7 placeholder:text-white/60 outline-none text-white font-medium placeholder:font-normal"
            type="email"
            value={email()}
            onChange={(e) => setEmail(e.target.value)}
            placeholder="me@example.com"
          />
          <button
            class={cx(
              `bg-gradient-to-b from-blue-400 to-blue-600 my-1.5 mr-1.5 p-[3px] rounded-full relative overflow-hidden cursor-pointer hover:scale-105 transition-[scale,opacity] duration-150 active:scale-95`,
              isLoading() && `!scale-0 opacity-0 pointer-events-none`,
            )}
            type="submit"
          >
            <div class="absolute w-full h-4 bg-gradient-to-b from-blue-300 to-transparent left-0 top-0" />
            <div class="absolute w-full h-4 bg-gradient-to-b from-transparent to-blue-700 left-0 bottom-0" />
            <div class="relative bg-gradient-to-b from-blue-400 to-blue-600 w-12 h-12 rounded-full flex items-center justify-center">
              <i class="fas fa-arrow-right text-2xl text-white" />
            </div>
          </button>
          <i
            class={cx(
              `fas fa-spinner text-3xl absolute right-4.5 top-4.5 transition-[scale,opacity] duration-150 delay-100 animate-spin text-white`,
              !isLoading() && `scale-0 opacity-0`,
            )}
          />
        </div>
      </div>
      <div
        class={cx(
          `bg-gradient-to-b from-red-50 to-red-200 shadow-xl shadow-red-700/20 rounded-3xl text-xl text-center text-red-900 font-medium p-8 absolute transition-[scale,opacity,filter] duration-200 delay-100 mt-7`,
          error() === null && `scale-90 opacity-0 blur-xl pointer-events-none`,
        )}
      >
        <p>{error()}</p>
        <p class="text-sm mt-2 opacity-80">Refresh the page and try again.</p>
      </div>
      <div
        class={cx(
          `bg-gradient-to-b from-white to-blue-200 shadow-xl shadow-blue-700/20 rounded-3xl text-xl text-center text-blue-900 font-medium p-8 absolute transition-[scale,opacity,filter] duration-200 delay-100 mt-7`,
          !isSuccess() && `scale-90 opacity-0 blur-xl pointer-events-none`,
        )}
      >
        <p>Check your email for a confirmation link!</p>
      </div>
    </form>
  );
};

export default WaitlistSignupForm;

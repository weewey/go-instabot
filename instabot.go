package main

import (
	"github.com/robfig/cron"
	"log"
	"os"
	"os/signal"
)

func main() {
	// Gets the command line options
	ParseOptions()
	// Gets the config
	GetConfig()
	// Tries to login
	Login()

	if *unfollow {
		SyncFollowers()
	} else if *run {
		// Loop through tags ; follows, likes, and comments, according to the config file
		log.Println("setting up cron job")
		c := cron.New()
		c.Start()
		err := c.AddFunc("@every 30m", LoopTags)
		if err != nil {
			log.Fatal(err.Error())
		}
	}
	sig := make(chan os.Signal)
	signal.Notify(sig, os.Interrupt, os.Kill)
	<-sig
}

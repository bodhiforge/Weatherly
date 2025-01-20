import React from 'react';

interface WeatherCardProps {
  weather: {
    name: string;
    main: { temp: number; humidity: number };
    wind: { speed: number };
    weather: { description: string }[];
  };
}

const WeatherCard: React.FC<WeatherCardProps> = ({ weather }) => (
  <div className="p-4 bg-blue-200 rounded shadow">
    <h2 className="text-2xl font-bold">{weather.name}</h2>
    <p className="text-lg">Description: {weather.weather[0].description}</p>
    <p>Temperature: {weather.main.temp}°C</p>
    <p>Humidity: {weather.main.humidity}%</p>
    <p>Wind Speed: {weather.wind.speed} m/s</p>
  </div>
);

export default WeatherCard;
